function setup_mcnCrossModalEmotions()
%SETUP_MCNCROSSMODALEMOTIONS Sets up mcnCrossModalEmotions, by adding
% its folders to the Matlab path
%
% Copyright (C) 2018 Samuel Albanie, Arsha Nagrani
% Licensed under The MIT License [see LICENSE.md for details]

  check_dependency('mcnDatasets') ;
  check_dependency('autonn') ;

  root = fileparts(mfilename('fullpath')) ;
  addpath(root, [root '/emoVoxCeleb']) ;
  addpath([root '/teacher'], [root '/misc'], [root '/external']) ;

% -----------------------------------
function check_dependency(moduleName)
% -----------------------------------

  name2path = @(name) strrep(name, '-', '_') ;
  setupFunc = ['setup_', name2path(moduleName)] ;
  if exist(setupFunc, 'file')
    vl_contrib('setup', moduleName) ;
  else
    % try adding the module to the path, supressing the warning
    warning('off', 'MATLAB:dispatcher:pathWarning') ;
    addpath(fullfile(vl_rootnn, 'contrib', moduleName)) ;
    warning('on', 'MATLAB:dispatcher:pathWarning') ;

    if exist(setupFunc, 'file')
      vl_contrib('setup', moduleName) ;
    else
      waiting = true ;
      msg = ['module %s was not found on the MATLAB path. Would you like ' ...
             'to install it now? (y/n)\n'] ;
      prompt = sprintf(msg, moduleName) ;
      while waiting
        str = input(prompt,'s') ;
        switch str
          case 'y'
            vl_contrib('install', moduleName) ;
            vl_contrib('compile', moduleName) ;
            vl_contrib('setup', moduleName) ;
            return ;
          case 'n'
            throw(exception) ;
          otherwise
            fprintf('input %s not recognised, please use `y` or `n`\n', str) ;
        end
      end
    end
  end

