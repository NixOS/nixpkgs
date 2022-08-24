# Hooks for building Python packages.
{ python
, lib
, makeSetupHook
, disabledIf
, isPy3k
, ensureNewerSourcesForZipFilesHook
, findutils
}:

let
  callPackage = python.pythonForBuild.pkgs.callPackage;
  pythonInterpreter = python.pythonForBuild.interpreter;
  pythonSitePackages = python.sitePackages;
  pythonCheckInterpreter = python.interpreter;
  setuppy = ../run_setup.py;
in rec {

  condaInstallHook = callPackage ({ gnutar, lbzip2 }:
    makeSetupHook {
      name = "conda-install-hook";
      deps = [ gnutar lbzip2 ];
      substitutions = {
        inherit pythonSitePackages;
      };
    } ./conda-install-hook.sh) {};

  condaUnpackHook = callPackage ({}:
    makeSetupHook {
      name = "conda-unpack-hook";
      deps = [];
    } ./conda-unpack-hook.sh) {};

  eggBuildHook = callPackage ({ }:
    makeSetupHook {
      name = "egg-build-hook.sh";
      deps = [ ];
    } ./egg-build-hook.sh) {};

  eggInstallHook = callPackage ({ setuptools }:
    makeSetupHook {
      name = "egg-install-hook.sh";
      deps = [ setuptools ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./egg-install-hook.sh) {};

  eggUnpackHook = callPackage ({ }:
    makeSetupHook {
      name = "egg-unpack-hook.sh";
      deps = [ ];
    } ./egg-unpack-hook.sh) {};

  flitBuildHook = callPackage ({ flit }:
    makeSetupHook {
      name = "flit-build-hook";
      deps = [ flit ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./flit-build-hook.sh) {};

  pipBuildHook = callPackage ({ pip, wheel }:
    makeSetupHook {
      name = "pip-build-hook.sh";
      deps = [ pip wheel ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pip-build-hook.sh) {};

  pipInstallHook = callPackage ({ pip }:
    makeSetupHook {
      name = "pip-install-hook";
      deps = [ pip ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pip-install-hook.sh) {};

  pytestCheckHook = callPackage ({ pytest }:
    makeSetupHook {
      name = "pytest-check-hook";
      deps = [ pytest ];
      substitutions = {
        inherit pythonCheckInterpreter;
      };
    } ./pytest-check-hook.sh) {};

  pythonCatchConflictsHook = callPackage ({ setuptools }:
    makeSetupHook {
      name = "python-catch-conflicts-hook";
      deps = [ setuptools ];
      substitutions = {
        inherit pythonInterpreter;
        catchConflicts=../catch_conflicts/catch_conflicts.py;
      };
    } ./python-catch-conflicts-hook.sh) {};

  pythonImportsCheckHook = callPackage ({}:
    makeSetupHook {
      name = "python-imports-check-hook.sh";
      substitutions = {
        inherit pythonCheckInterpreter;
      };
    } ./python-imports-check-hook.sh) {};

  pythonNamespacesHook = callPackage ({}:
    makeSetupHook {
      name = "python-namespaces-hook.sh";
      substitutions = {
        inherit pythonSitePackages findutils;
      };
    } ./python-namespaces-hook.sh) {};

  pythonRecompileBytecodeHook = callPackage ({ }:
    makeSetupHook {
      name = "python-recompile-bytecode-hook";
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
        compileArgs = lib.concatStringsSep " " (["-q" "-f" "-i -"] ++ lib.optionals isPy3k ["-j $NIX_BUILD_CORES"]);
        bytecodeName = if isPy3k then "__pycache__" else "*.pyc";
      };
    } ./python-recompile-bytecode-hook.sh ) {};

  pythonRelaxDepsHook = callPackage ({ wheel }:
    makeSetupHook {
      name = "python-relax-deps-hook";
      deps = [ wheel ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./python-relax-deps-hook.sh) {};

  pythonRemoveBinBytecodeHook = callPackage ({ }:
    makeSetupHook {
      name = "python-remove-bin-bytecode-hook";
    } ./python-remove-bin-bytecode-hook.sh) {};

  pythonRemoveTestsDirHook = callPackage ({ }:
    makeSetupHook {
      name = "python-remove-tests-dir-hook";
      substitutions = {
        inherit pythonSitePackages;
      };
    } ./python-remove-tests-dir-hook.sh) {};

  setuptoolsBuildHook = callPackage ({ setuptools, wheel }:
    makeSetupHook {
      name = "setuptools-setup-hook";
      deps = [ setuptools wheel ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages setuppy;
      };
    } ./setuptools-build-hook.sh) {};

  setuptoolsCheckHook = callPackage ({ setuptools }:
    makeSetupHook {
      name = "setuptools-check-hook";
      deps = [ setuptools ];
      substitutions = {
        inherit pythonCheckInterpreter setuppy;
      };
    } ./setuptools-check-hook.sh) {};

  unittestCheckHook = callPackage ({ }:
    makeSetupHook {
      name = "unittest-check-hook";
      substitutions = {
        inherit pythonCheckInterpreter;
      };
    } ./unittest-check-hook.sh) {};

  venvShellHook = disabledIf (!isPy3k) (callPackage ({ }:
    makeSetupHook {
      name = "venv-shell-hook";
      deps = [ ensureNewerSourcesForZipFilesHook ];
      substitutions = {
        inherit pythonInterpreter;
      };
    } ./venv-shell-hook.sh) {});

  wheelUnpackHook = callPackage ({ wheel }:
    makeSetupHook {
      name = "wheel-unpack-hook.sh";
      deps = [ wheel ];
    } ./wheel-unpack-hook.sh) {};

  sphinxHook = callPackage ({ sphinx }:
    makeSetupHook {
      name = "python${python.pythonVersion}-sphinx-hook";
      deps = [ sphinx ];
    } ./sphinx-hook.sh) {};
}
