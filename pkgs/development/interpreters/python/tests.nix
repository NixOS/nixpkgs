# Tests for the Python interpreters, package sets and environments.
#
# Each Python interpreter has a `passthru.tests` which is the attribute set
# returned by this function. For example, for Python 3 the tests are run with
#
# $ nix-build -A python3.tests
#
{ stdenv
, python
, runCommand
, substituteAll
, lib
, callPackage
, pkgs
}:

let
  # Test whether the interpreter behaves in the different types of environments
  # we aim to support.
  environmentTests = let
    envs = let
      inherit python;
      pythonEnv = python.withPackages(ps: with ps; [ ]);
      pythonVirtualEnv = if python.isPy3k
        then
           python.withPackages(ps: with ps; [ virtualenv ])
        else
          python.buildEnv.override {
            extraLibs = with python.pkgs; [ virtualenv ];
            # Collisions because of namespaces __init__.py
            ignoreCollisions = true;
          };
    in {
      # Plain Python interpreter
      plain = rec {
        env = python;
        interpreter = env.interpreter;
        is_venv = "False";
        is_nixenv = "False";
        is_virtualenv = "False";
      };
    } // lib.optionalAttrs (!python.isPyPy) {
      # Use virtualenv from a Nix env.
      nixenv-virtualenv = rec {
        env = runCommand "${python.name}-virtualenv" {} ''
          ${pythonVirtualEnv.interpreter} -m virtualenv $out
        '';
        interpreter = "${env}/bin/${python.executable}";
        is_venv = "False";
        is_nixenv = "True";
        is_virtualenv = "True";
      };
    } // lib.optionalAttrs (python.implementation != "graal") {
      # Python Nix environment (python.buildEnv)
      nixenv = rec {
        env = pythonEnv;
        interpreter = env.interpreter;
        is_venv = "False";
        is_nixenv = "True";
        is_virtualenv = "False";
      };
    } // lib.optionalAttrs (python.isPy3k && (!python.isPyPy)) rec {
      # Venv built using plain Python
      # Python 2 does not support venv
      # TODO: PyPy executable name is incorrect, it should be pypy-c or pypy-3c instead of pypy and pypy3.
      plain-venv = rec {
        env = runCommand "${python.name}-venv" {} ''
          ${python.interpreter} -m venv $out
        '';
        interpreter = "${env}/bin/${python.executable}";
        is_venv = "True";
        is_nixenv = "False";
        is_virtualenv = "False";
      };

    } // lib.optionalAttrs (python.pythonAtLeast "3.8") {
      # Venv built using Python Nix environment (python.buildEnv)
      # TODO: Cannot create venv from a  nix env
      # Error: Command '['/nix/store/ddc8nqx73pda86ibvhzdmvdsqmwnbjf7-python3-3.7.6-venv/bin/python3.7', '-Im', 'ensurepip', '--upgrade', '--default-pip']' returned non-zero exit status 1.
      nixenv-venv = rec {
        env = runCommand "${python.name}-venv" {} ''
          ${pythonEnv.interpreter} -m venv $out
        '';
        interpreter = "${env}/bin/${pythonEnv.executable}";
        is_venv = "True";
        is_nixenv = "True";
        is_virtualenv = "False";
      };
    };

    testfun = name: attrs: runCommand "${python.name}-tests-${name}" ({
      inherit (python) pythonVersion;
    } // attrs) ''
      cp -r ${./tests/test_environments} tests
      chmod -R +w tests
      substituteAllInPlace tests/test_python.py
      ${attrs.interpreter} -m unittest discover --verbose tests #/test_python.py
      mkdir $out
      touch $out/success
    '';

  in lib.mapAttrs testfun envs;

  # Integration tests involving the package set.
  # All PyPy package builds are broken at the moment
  integrationTests = lib.optionalAttrs (!python.isPyPy) (
    lib.optionalAttrs (python.isPy3k && !stdenv.isDarwin) { # darwin has no split-debug
      cpython-gdb = callPackage ./tests/test_cpython_gdb {
        interpreter = python;
      };
    } // lib.optionalAttrs (python.pythonAtLeast "3.7") rec {
      # Before the addition of NIX_PYTHONPREFIX mypy was broken with typed packages
      nix-pythonprefix-mypy = callPackage ./tests/test_nix_pythonprefix {
        interpreter = python;
      };
    }
  );

  # Tests to ensure overriding works as expected.
  overrideTests = let
    extension = self: super: {
      foobar = super.numpy;
    };
  in {
    test-packageOverrides = let
      myPython = let
        self = python.override {
          packageOverrides = extension;
          inherit self;
        };
      in self;
    in assert myPython.pkgs.foobar == myPython.pkgs.numpy; myPython.withPackages(ps: with ps; [ foobar ]);
    # overrideScope is broken currently
    # test-overrideScope = let
    #  myPackages = python.pkgs.overrideScope extension;
    # in assert myPackages.foobar == myPackages.numpy; myPackages.python.withPackages(ps: with ps; [ foobar ]);
  } // lib.optionalAttrs (python ? pythonAttr) {
    # Test applying overrides using pythonPackagesOverlays.
    test-pythonPackagesExtensions = let
      pkgs_ = pkgs.extend(final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            foo = python-prev.setuptools;
          })
        ];
      });
    in pkgs_.${python.pythonAttr}.pkgs.foo;
  };

  condaTests = let
    requests = callPackage ({
        autoPatchelfHook,
        fetchurl,
        pythonCondaPackages,
      }:
      python.pkgs.buildPythonPackage {
        pname = "requests";
        version = "2.24.0";
        format = "other";
        src = fetchurl {
          url = "https://repo.anaconda.com/pkgs/main/noarch/requests-2.24.0-py_0.tar.bz2";
          sha256 = "02qzaf6gwsqbcs69pix1fnjxzgnngwzvrsy65h1d521g750mjvvp";
        };
        nativeBuildInputs = [ autoPatchelfHook ] ++ (with python.pkgs; [
          condaUnpackHook condaInstallHook
        ]);
        buildInputs = [
          pythonCondaPackages.condaPatchelfLibs
        ];
        propagatedBuildInputs = with python.pkgs; [
          chardet idna urllib3 certifi
        ];
      }
    ) {};
    pythonWithRequests = requests.pythonModule.withPackages (ps: [ requests ]);
    in
    {
      condaExamplePackage = runCommand "import-requests" {} ''
        ${pythonWithRequests.interpreter} -c "import requests" > $out
      '';
    };

in lib.optionalAttrs (stdenv.hostPlatform == stdenv.buildPlatform ) (environmentTests // integrationTests // overrideTests // condaTests)
