# Tests for the Python interpreters, package sets and environments.
#
# Each Python interpreter has a `passthru.tests` which is the attribute set
# returned by this function. For example, for Python 3 the tests are run with
#
# $ nix-build -A python3.tests
#
{
  stdenv,
  python,
  runCommand,
  lib,
  callPackage,
  pkgs,
}:

let
  # Test whether the interpreter behaves in the different types of environments
  # we aim to support.
  environmentTests =
    let
      inherit (python) pythonOnBuildForHost;

      environments =
        let
          python = pythonOnBuildForHost;
          pythonEnv = python.withPackages (ps: [ ]);
          pythonVirtualEnv =
            if python.isPy3k then
              python.withPackages (ps: with ps; [ virtualenv ])
            else
              python.buildEnv.override {
                extraLibs = with python.pkgs; [ virtualenv ];
                # Collisions because of namespaces __init__.py
                ignoreCollisions = true;
              };
        in
        {
          # Plain Python interpreter
          plain = rec {
            environment = python;
            interpreter = environment.interpreter;
            is_venv = "False";
            is_nixenv = "False";
            is_virtualenv = "False";
          };
        }
        // lib.optionalAttrs (!python.isPyPy && !stdenv.buildPlatform.isDarwin) {
          # Use virtualenv from a Nix env.
          # Fails on darwin with
          #   virtualenv: error: argument dest: the destination . is not write-able at /nix/store
          nixenv-virtualenv = rec {
            environment = runCommand "${python.name}-virtualenv" { } ''
              ${pythonVirtualEnv.interpreter} -m virtualenv venv
              mv venv $out
            '';
            interpreter = "${environment}/bin/${python.executable}";
            is_venv = "False";
            is_nixenv = "True";
            is_virtualenv = "True";
          };
        }
        // lib.optionalAttrs (python.implementation != "graal") {
          # Python Nix environment (python.buildEnv)
          nixenv = rec {
            environment = pythonEnv;
            interpreter = environment.interpreter;
            is_venv = "False";
            is_nixenv = "True";
            is_virtualenv = "False";
          };
        }
        // lib.optionalAttrs (python.isPy3k && (!python.isPyPy)) {
          # Venv built using plain Python
          # Python 2 does not support venv
          # TODO: PyPy executable name is incorrect, it should be pypy-c or pypy-3c instead of pypy and pypy3.
          plain-venv = rec {
            environment = runCommand "${python.name}-venv" { } ''
              ${python.interpreter} -m venv $out
            '';
            interpreter = "${environment}/bin/${python.executable}";
            is_venv = "True";
            is_nixenv = "False";
            is_virtualenv = "False";
          };

        }
        // {
          # Venv built using Python Nix environment (python.buildEnv)
          # TODO: Cannot create venv from a  nix env
          # Error: Command '['/nix/store/ddc8nqx73pda86ibvhzdmvdsqmwnbjf7-python3-3.7.6-venv/bin/python3.7', '-Im', 'ensurepip', '--upgrade', '--default-pip']' returned non-zero exit status 1.
          nixenv-venv = rec {
            environment = runCommand "${python.name}-venv" { } ''
              ${pythonEnv.interpreter} -m venv $out
            '';
            interpreter = "${environment}/bin/${pythonEnv.executable}";
            is_venv = "True";
            is_nixenv = "True";
            is_virtualenv = "False";
          };
        };

      testfun =
        name: attrs:
        runCommand "${python.name}-tests-${name}"
          (
            {
              inherit (python) pythonVersion;
              pythonPrefix = pythonOnBuildForHost;
            }
            // attrs
          )
          ''
            cp -r ${./tests/test_environments} tests
            chmod -R +w tests
            substituteAllInPlace tests/test_python.py
            ${attrs.interpreter} -m unittest discover --verbose tests #/test_python.py
            mkdir $out
            touch $out/success
          '';

    in
    lib.mapAttrs testfun environments;

  # Integration tests involving the package set.
  # All PyPy package builds are broken at the moment
  integrationTests = lib.optionalAttrs (!python.isPyPy) (
    {
      # Make sure tkinter is importable. See https://github.com/NixOS/nixpkgs/issues/238990
      tkinter = callPackage ./tests/test_tkinter {
        interpreter = python.pythonOnBuildForHost;
      };
    }
    //
      lib.optionalAttrs
        (
          python.isPy3k
          # Fails on Python 3.13.
          && python.pythonOlder "3.13"
          # Darwin has no split-debug.
          && !stdenv.buildPlatform.isDarwin
        )
        {
          cpython-gdb = callPackage ./tests/test_cpython_gdb {
            interpreter = python.pythonOnBuildForHost;

            # GDB must target the build platform to debug this interpreter.
            gdb = pkgs.pkgsBuildBuild.gdb;
          };
        }
    // lib.optionalAttrs (python.isPy3k && python.pythonOlder "3.13") {
      # Before the addition of NIX_PYTHONPREFIX mypy was broken with typed packages
      # mypy does not yet support python3.13
      # https://github.com/python/mypy/issues/17264
      nix-pythonprefix-mypy = callPackage ./tests/test_nix_pythonprefix {
        interpreter = python.pythonOnBuildForHost;
      };
    }
  );

  # Test editable package support
  editableTests =
    let
      testPython = python.pythonOnBuildForHost.override {
        self = testPython;
        packageOverrides = pyfinal: pyprev: {
          # An editable package with a script that loads our mutable location
          my-editable = pyfinal.mkPythonEditablePackage {
            pname = "my-editable";
            version = "0.1.0";
            root = "$NIX_BUILD_TOP/src"; # Use environment variable expansion at runtime
            # Inject a script
            scripts = {
              my-script = "my_editable.main:main";
            };
          };
        };
      };

    in
    # mkPythonEditablePackage builds wheels with Hatchling.
    lib.optionalAttrs (!testPython.pkgs.hatchling.disabled) {
      editable-script =
        runCommand "editable-test"
          {
            nativeBuildInputs = [ (testPython.withPackages (ps: [ ps.my-editable ])) ];
          }
          ''
            mkdir -p src/my_editable

            cat > src/my_editable/main.py << EOF
            def main():
              print("hello mutable")
            EOF

            test "$(my-script)" == "hello mutable"
            test "$(${testPython.executable} -c 'import sys; print(sys.path[1])')" == "$NIX_BUILD_TOP/src"

            touch $out
          '';
    };

  # Tests to ensure overriding works as expected.
  overrideTests =
    let
      pythonEnv = python.pythonOnBuildForHost.withPackages (_: [ ]);
      postBuildMarker = old: {
        postBuild = old.postBuild + ''
          echo preserved > "$out/override-marker"
        '';
      };
      testPostBuild =
        method:
        runCommand "${python.name}-with-packages-${method}"
          {
            nativeBuildInputs = [ (pythonEnv.${method} postBuildMarker) ];
          }
          ''
            test "$(cat "$(dirname "$(command -v ${python.executable})")/../override-marker")" = preserved
            touch "$out"
          '';

      extension = self: super: {
        foobar = super.six;
      };
      # `pythonInterpreters.pypy39_prebuilt` does not expose an attribute
      # name (is not present in top-level `pkgs`).
      is_prebuilt = python: python.pythonAttr == null;
    in
    lib.optionalAttrs (python.isPy3k) (
      {
        with-packages-override =
          runCommand "${python.name}-with-packages-override"
            {
              nativeBuildInputs = [
                (pythonEnv.override {
                  makeWrapperArgs = [ "--set PYTHON_ENV_TEST preserved" ];
                })
              ];
            }
            ''
              ${python.executable} - <<'PY'
              import os

              assert os.environ.get("PYTHON_ENV_TEST") == "preserved", "Python environment override was lost"
              PY

              touch "$out"
            '';

        with-packages-overrideAttrs = testPostBuild "overrideAttrs";

        with-packages-overrideDerivation = testPostBuild "overrideDerivation";

        with-packages-override-chained =
          runCommand "${python.name}-with-packages-override-chained"
            {
              nativeBuildInputs = [
                ((pythonEnv.overrideAttrs postBuildMarker).override {
                  makeWrapperArgs = [ "--set PYTHON_ENV_TEST preserved" ];
                })
              ];
            }
            ''
              ${python.executable} - <<'PY'
              import os

              assert os.environ.get("PYTHON_ENV_TEST") == "preserved", "Python environment override was lost"
              PY

              test "$(cat "$(dirname "$(command -v ${python.executable})")/../override-marker")" = preserved
              touch "$out"
            '';

        test-packageOverrides =
          let
            myPython = python.pythonOnBuildForHost.override {
              packageOverrides = extension;
              self = myPython;
            };
          in
          assert myPython.pkgs.foobar == myPython.pkgs.six;
          assert myPython.pkgs.python.pkgs.foobar == myPython.pkgs.six;
          assert
            myPython.pkgs.python.withPackages (ps: with ps; [ foobar ])
            == myPython.withPackages (ps: with ps; [ six ]);
          runCommand "${python.name}-packageOverrides"
            {
              nativeBuildInputs = [ (myPython.withPackages (ps: [ ps.foobar ])) ];
            }
            ''
              ${myPython.executable} -c 'import six'
              touch "$out"
            '';
        test-overrideScope =
          let
            myPackages = python.pkgs.overrideScope extension;
          in
          assert myPackages.foobar == myPackages.six;
          assert myPackages.python.pkgs.foobar == myPackages.six;
          myPackages.python.withPackages (
            ps: with ps; [
              foobar
              ps.python.pkgs.foobar
            ]
          );

        with-packages-overrideScope =
          let
            myPackages = python.pythonOnBuildForBuild.pkgs.overrideScope extension;
          in
          runCommand "${python.name}-with-packages-overrideScope"
            {
              nativeBuildInputs = [ (myPackages.python.withPackages (ps: [ ps.foobar ])) ];
            }
            ''
              ${python.executable} -c 'import six'
              touch "$out"
            '';
        #
        # Have to skip prebuilt python as it's not present in top-level
        # `pkgs` as an attribute.
      }
      // lib.optionalAttrs (python ? pythonAttr && !is_prebuilt python) {
        # Test applying overrides using pythonPackagesOverlays.
        test-pythonPackagesExtensions =
          let
            pkgs_ = pkgs.extend (
              final: prev: {
                pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
                  (python-final: python-prev: {
                    foo = python-prev.setuptools;
                  })
                ];
              }
            );
          in
          pkgs_.${python.pythonAttr}.pkgs.foo;
      }
    );

  # Test importing a package installed from a Conda archive.
  condaTests =
    let
      testPython = python.pythonOnBuildForHost;
      requests = pkgs.pkgsBuildBuild.callPackage (
        {
          autoPatchelfHook,
          fetchurl,
          pythonCondaPackages,
        }:
        testPython.pkgs.buildPythonPackage {
          pname = "requests";
          version = "2.24.0";
          pyproject = false;
          src = fetchurl {
            url = "https://repo.anaconda.com/pkgs/main/noarch/requests-2.24.0-py_0.tar.bz2";
            sha256 = "02qzaf6gwsqbcs69pix1fnjxzgnngwzvrsy65h1d521g750mjvvp";
          };
          nativeBuildInputs = [
            autoPatchelfHook
          ]
          ++ (with testPython.pkgs; [
            condaUnpackHook
            condaInstallHook
          ]);
          buildInputs = pythonCondaPackages.condaPatchelfLibs;
          propagatedBuildInputs = with testPython.pkgs; [
            chardet
            idna
            urllib3
            certifi
          ];
        }
      ) { };
      pythonWithRequests = requests.pythonModule.withPackages (ps: [ requests ]);
    in
    lib.optionalAttrs (!python.isPyPy && python.isPy3k && stdenv.buildPlatform.isLinux) {
      condaExamplePackage = runCommand "import-requests" { } ''
        ${pythonWithRequests.interpreter} -c "import requests" > $out
      '';
    };

  crossTests =
    let
      debugPython = python.override {
        enableDebug = true;
        self = debugPython;
      };

      testEnvironment =
        {
          name,
          interpreter ? python,
          selectOutput ? lib.id,
          expectDebug ? false,
        }:
        runCommand "${python.name}-${name}"
          {
            nativeBuildInputs = [ (selectOutput (interpreter.withPackages (ps: [ ps.cffi ]))) ];
          }
          ''
            # Both the interpreter and the compiled extension must run on the build platform.
            python - <<'PY'
            import cffi
            import _cffi_backend
            import sysconfig

            assert bool(sysconfig.get_config_var("Py_DEBUG")) == ${if expectDebug then "True" else "False"}
            PY

            touch "$out"
          '';
    in
    {
      with-packages-native = testEnvironment {
        name = "with-packages-native";
      };

      with-packages-native-package-set = testEnvironment {
        name = "with-packages-native-package-set";
        interpreter = python.pkgs.python;
      };

      with-packages-native-output = testEnvironment {
        name = "with-packages-native-output";
        selectOutput = env: env.out;
      };

      with-packages-native-debug = testEnvironment {
        name = "with-packages-native-debug";
        interpreter = debugPython;
        expectDebug = true;
      };
    };

in
# The debug interpreter test requires CPython's enableDebug and Py_DEBUG.
lib.optionalAttrs (
  stdenv.hostPlatform != stdenv.buildPlatform && python.implementation == "cpython"
) crossTests
// overrideTests
// editableTests
// environmentTests
// integrationTests
// condaTests
