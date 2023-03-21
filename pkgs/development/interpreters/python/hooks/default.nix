self: super: with self;

let
  pythonInterpreter = super.python.pythonForBuild.interpreter;
  pythonSitePackages = super.python.sitePackages;
  pythonCheckInterpreter = super.python.interpreter;
  setuppy = ../run_setup.py;
in {
  makePythonHook = args: pkgs.makeSetupHook ({passthru.provides.setupHook = true; } // args);

  condaInstallHook = callPackage ({ makePythonHook, gnutar, lbzip2 }:
    makePythonHook {
      name = "conda-install-hook";
      propagatedBuildInputs = [ gnutar lbzip2 ];
      substitutions = {
        inherit pythonSitePackages;
      };
    } ./conda-install-hook.sh) {};

  condaUnpackHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "conda-unpack-hook";
      propagatedBuildInputs = [];
    } ./conda-unpack-hook.sh) {};

  eggBuildHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "egg-build-hook.sh";
      propagatedBuildInputs = [ ];
    } ./egg-build-hook.sh) {};

  eggInstallHook = callPackage ({ makePythonHook, setuptools }:
    makePythonHook {
      name = "egg-install-hook.sh";
      propagatedBuildInputs = [ setuptools ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./egg-install-hook.sh) {};

  eggUnpackHook = callPackage ({ makePythonHook, }:
    makePythonHook {
      name = "egg-unpack-hook.sh";
      propagatedBuildInputs = [ ];
    } ./egg-unpack-hook.sh) {};

  flitBuildHook = callPackage ({ makePythonHook, flit }:
    makePythonHook {
      name = "flit-build-hook";
      propagatedBuildInputs = [ flit ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./flit-build-hook.sh) {};

  pipBuildHook = callPackage ({ makePythonHook, pip, wheel }:
    makePythonHook {
      name = "pip-build-hook.sh";
      propagatedBuildInputs = [ pip wheel ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pip-build-hook.sh) {};

  pipInstallHook = callPackage ({ makePythonHook, pip }:
    makePythonHook {
      name = "pip-install-hook";
      propagatedBuildInputs = [ pip ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pip-install-hook.sh) {};

  pytestCheckHook = callPackage ({ makePythonHook, pytest }:
    makePythonHook {
      name = "pytest-check-hook";
      propagatedBuildInputs = [ pytest ];
      substitutions = {
        inherit pythonCheckInterpreter;
      };
    } ./pytest-check-hook.sh) {};

  pythonCatchConflictsHook = callPackage ({ makePythonHook, setuptools }:
    makePythonHook {
      name = "python-catch-conflicts-hook";
      substitutions = {
        inherit pythonInterpreter pythonSitePackages setuptools;
        catchConflicts=../catch_conflicts/catch_conflicts.py;
      };
    } ./python-catch-conflicts-hook.sh) {};

  pythonImportsCheckHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "python-imports-check-hook.sh";
      substitutions = {
        inherit pythonCheckInterpreter pythonSitePackages;
      };
    } ./python-imports-check-hook.sh) {};

  pythonNamespacesHook = callPackage ({ makePythonHook, findutils }:
    makePythonHook {
      name = "python-namespaces-hook.sh";
      substitutions = {
        inherit pythonSitePackages findutils;
      };
    } ./python-namespaces-hook.sh) {};

  pythonOutputDistHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "python-output-dist-hook";
  } ./python-output-dist-hook.sh ) {};

  pythonRecompileBytecodeHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "python-recompile-bytecode-hook";
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
        compileArgs = lib.concatStringsSep " " (["-q" "-f" "-i -"] ++ lib.optionals isPy3k ["-j $NIX_BUILD_CORES"]);
        bytecodeName = if isPy3k then "__pycache__" else "*.pyc";
      };
    } ./python-recompile-bytecode-hook.sh ) {};

  pythonRelaxDepsHook = callPackage ({ makePythonHook, wheel }:
    makePythonHook {
      name = "python-relax-deps-hook";
      propagatedBuildInputs = [ wheel ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./python-relax-deps-hook.sh) {};

  pythonRemoveBinBytecodeHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "python-remove-bin-bytecode-hook";
    } ./python-remove-bin-bytecode-hook.sh) {};

  pythonRemoveTestsDirHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "python-remove-tests-dir-hook";
      substitutions = {
        inherit pythonSitePackages;
      };
    } ./python-remove-tests-dir-hook.sh) {};

  setuptoolsBuildHook = callPackage ({ makePythonHook, setuptools, wheel }:
    makePythonHook {
      name = "setuptools-setup-hook";
      propagatedBuildInputs = [ setuptools wheel ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages setuppy;
      };
    } ./setuptools-build-hook.sh) {};

  setuptoolsCheckHook = callPackage ({ makePythonHook, setuptools }:
    makePythonHook {
      name = "setuptools-check-hook";
      propagatedBuildInputs = [ setuptools ];
      substitutions = {
        inherit pythonCheckInterpreter setuppy;
      };
    } ./setuptools-check-hook.sh) {};

  unittestCheckHook = callPackage ({ makePythonHook }:
    makePythonHook {
      name = "unittest-check-hook";
      substitutions = {
        inherit pythonCheckInterpreter;
      };
    } ./unittest-check-hook.sh) {};

  venvShellHook = disabledIf (!isPy3k) (callPackage ({ makePythonHook, ensureNewerSourcesForZipFilesHook }:
    makePythonHook {
      name = "venv-shell-hook";
      propagatedBuildInputs = [ ensureNewerSourcesForZipFilesHook ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./venv-shell-hook.sh) {});

  wheelUnpackHook = callPackage ({ makePythonHook, wheel }:
    makePythonHook {
      name = "wheel-unpack-hook.sh";
      propagatedBuildInputs = [ wheel ];
    } ./wheel-unpack-hook.sh) {};

  wrapPython = callPackage ../wrap-python.nix {
    inherit (pkgs.buildPackages) makeWrapper;
  };

  sphinxHook = callPackage ({ makePythonHook, sphinx, installShellFiles }:
    makePythonHook {
      name = "python${python.pythonVersion}-sphinx-hook";
      propagatedBuildInputs = [ sphinx installShellFiles ];
    } ./sphinx-hook.sh) {};
}
