self: dontUse: with self;

let
  inherit (python) pythonForBuild;
  pythonInterpreter = pythonForBuild.interpreter;
  pythonSitePackages = python.sitePackages;
  pythonCheckInterpreter = python.interpreter;
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

  pypaBuildHook = callPackage ({ makePythonHook, build, wheel }:
    makePythonHook {
      name = "pypa-build-hook.sh";
      propagatedBuildInputs = [ build wheel ];
    } ./pypa-build-hook.sh) {
      inherit (pythonForBuild.pkgs) build;
    };

  pipInstallHook = callPackage ({ makePythonHook, pip }:
    makePythonHook {
      name = "pip-install-hook";
      propagatedBuildInputs = [ pip ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pip-install-hook.sh) {};

  pypaInstallHook = callPackage ({ makePythonHook, installer }:
    makePythonHook {
      name = "pypa-install-hook";
      propagatedBuildInputs = [ installer ];
      substitutions = {
        inherit pythonInterpreter pythonSitePackages;
      };
    } ./pypa-install-hook.sh) {
      inherit (pythonForBuild.pkgs) installer;
    };

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

  pythonNamespacesHook = callPackage ({ makePythonHook, buildPackages }:
    makePythonHook {
      name = "python-namespaces-hook.sh";
      substitutions = {
        inherit pythonSitePackages;
        inherit (buildPackages) findutils;
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
      substitutions = {
        inherit pythonInterpreter pythonSitePackages wheel;
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

    setuptoolsRustBuildHook = callPackage ({ makePythonHook, setuptools-rust, rust }:
      makePythonHook {
        name = "setuptools-rust-setup-hook";
        propagatedBuildInputs = [ setuptools-rust ];
        substitutions = {
          pyLibDir = "${python}/lib/${python.libPrefix}";
          cargoBuildTarget = rust.toRustTargetSpec stdenv.hostPlatform;
          cargoLinkerVar = lib.toUpper (
              builtins.replaceStrings ["-"] ["_"] (
                rust.toRustTarget stdenv.hostPlatform));
          targetLinker = "${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc";
        };
      } ./setuptools-rust-hook.sh) {};

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
