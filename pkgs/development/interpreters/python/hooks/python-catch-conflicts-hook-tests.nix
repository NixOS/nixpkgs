{
  pythonOnBuildForHost,
  runCommand,
  writeShellScript,
  coreutils,
  gnugrep,
}:
let

  pythonPkgs = pythonOnBuildForHost.pkgs;

  ### UTILITIES

  # customize a package so that its store paths differs
  customize = pkg: pkg.overrideAttrs { some_modification = true; };

  # generates minimal pyproject.toml
  pyprojectToml =
    pname:
    builtins.toFile "pyproject.toml" ''
      [project]
      name = "${pname}"
      version = "1.0.0"
    '';

  # generates source for a python project
  projectSource =
    pname:
    runCommand "my-project-source" { } ''
      mkdir -p $out/src
      cp ${pyprojectToml pname} $out/pyproject.toml
      touch $out/src/__init__.py
    '';

  # helper to reduce boilerplate
  generatePythonPackage =
    args:
    pythonPkgs.buildPythonPackage (
      {
        version = "1.0.0";
        src = runCommand "my-project-source" { } ''
          mkdir -p $out/src
          cp ${pyprojectToml args.pname} $out/pyproject.toml
          touch $out/src/__init__.py
        '';
        pyproject = true;
        catchConflicts = true;
        buildInputs = [ pythonPkgs.setuptools ];
      }
      // args
    );

  # in order to test for a failing build, wrap it in a shell script
  expectFailure =
    build: errorMsg:
    build.overrideDerivation (old: {
      builder = writeShellScript "test-for-failure" ''
        export PATH=${coreutils}/bin:${gnugrep}/bin:$PATH
        ${old.builder} "$@" > ./log 2>&1
        status=$?
        cat ./log
        if [ $status -eq 0 ] || ! grep -q "${errorMsg}" ./log; then
          echo "The build should have failed with '${errorMsg}', but it didn't"
          exit 1
        else
          echo "The build failed as expected with: ${errorMsg}"
          mkdir -p $out
        fi
      '';
    });
in
{

  ### TEST CASES

  # Test case which must not trigger any conflicts.
  # This derivation has runtime dependencies on custom versions of multiple build tools.
  # This scenario is relevant for lang2nix tools which do not override the nixpkgs fix-point.
  # see https://github.com/NixOS/nixpkgs/issues/283695
  ignores-build-time-deps = generatePythonPackage {
    pname = "ignores-build-time-deps";
    buildInputs = [
      pythonPkgs.build
      pythonPkgs.packaging
      pythonPkgs.setuptools
      pythonPkgs.wheel
    ];
    propagatedBuildInputs = [
      # Add customized versions of build tools as runtime deps
      (customize pythonPkgs.packaging)
      (customize pythonPkgs.setuptools)
      (customize pythonPkgs.wheel)
    ];
  };

  # multi-output derivation with dependency on itself must not crash
  cyclic-dependencies = generatePythonPackage {
    pname = "cyclic-dependencies";
    preFixup = ''
      propagatedBuildInputs+=("$out")
    '';
  };

  # Simplest test case that should trigger a conflict
  catches-simple-conflict =
    let
      # this build must fail due to conflicts
      package = pythonPkgs.buildPythonPackage rec {
        pname = "catches-simple-conflict";
        version = "0.0.0";
        src = projectSource pname;
        pyproject = true;
        catchConflicts = true;
        buildInputs = [
          pythonPkgs.setuptools
        ];
        # depend on two different versions of packaging
        # (an actual runtime dependency conflict)
        propagatedBuildInputs = [
          pythonPkgs.packaging
          (customize pythonPkgs.packaging)
        ];
      };
    in
    expectFailure package "Found duplicated packages in closure for dependency 'packaging'";

  /*
    More complex test case with a transitive conflict

    Test sets up this dependency tree:

      toplevel
      ├── dep1
      │   └── leaf
      └── dep2
          └── leaf (customized version -> conflicting)
  */
  catches-transitive-conflict =
    let
      # package depending on both dependency1 and dependency2
      toplevel = generatePythonPackage {
        pname = "catches-transitive-conflict";
        propagatedBuildInputs = [
          dep1
          dep2
        ];
      };
      # dep1 package depending on leaf
      dep1 = generatePythonPackage {
        pname = "dependency1";
        propagatedBuildInputs = [ leaf ];
      };
      # dep2 package depending on conflicting version of leaf
      dep2 = generatePythonPackage {
        pname = "dependency2";
        propagatedBuildInputs = [ (customize leaf) ];
      };
      # some leaf package
      leaf = generatePythonPackage {
        pname = "leaf";
      };
    in
    expectFailure toplevel "Found duplicated packages in closure for dependency 'leaf'";

  /*
    Transitive conflict with multiple dependency chains leading to the
    conflicting package.

    Test sets up this dependency tree:

      toplevel
      ├── dep1
      │   └── leaf
      ├── dep2
      │   └── leaf
      └── dep3
          └── leaf (customized version -> conflicting)
  */
  catches-conflict-multiple-chains =
    let
      # package depending on dependency1, dependency2 and dependency3
      toplevel = generatePythonPackage {
        pname = "catches-conflict-multiple-chains";
        propagatedBuildInputs = [
          dep1
          dep2
          dep3
        ];
      };
      # dep1 package depending on leaf
      dep1 = generatePythonPackage {
        pname = "dependency1";
        propagatedBuildInputs = [ leaf ];
      };
      # dep2 package depending on leaf
      dep2 = generatePythonPackage {
        pname = "dependency2";
        propagatedBuildInputs = [ leaf ];
      };
      # dep3 package depending on conflicting version of leaf
      dep3 = generatePythonPackage {
        pname = "dependency3";
        propagatedBuildInputs = [ (customize leaf) ];
      };
      # some leaf package
      leaf = generatePythonPackage {
        pname = "leaf";
      };
    in
    expectFailure toplevel "Found duplicated packages in closure for dependency 'leaf'";
}
