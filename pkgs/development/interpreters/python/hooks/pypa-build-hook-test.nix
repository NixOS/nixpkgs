{ pythonOnBuildForHost, runCommand }:
{
  dont-propagate-conflicting-deps =
    let
      # customize a package so that its store paths differs
      mkConflict = pkg: pkg.overrideAttrs { some_modification = true; };
      # minimal pyproject.toml for the example project
      pyprojectToml = builtins.toFile "pyproject.toml" ''
        [project]
        name = "my-project"
        version = "1.0.0"
      '';
      # the source of the example project
      projectSource = runCommand "my-project-source" { } ''
        mkdir -p $out/src
        cp ${pyprojectToml} $out/pyproject.toml
        touch $out/src/__init__.py
      '';
    in
    # this build must never triger conflicts
    pythonOnBuildForHost.pkgs.buildPythonPackage {
      pname = "dont-propagate-conflicting-deps";
      version = "0.0.0";
      src = projectSource;
      format = "pyproject";
      propagatedBuildInputs = [
        # At least one dependency of `build` should be included here to
        # keep the test meaningful
        (mkConflict pythonOnBuildForHost.pkgs.tomli)
        # setuptools is also needed to build the example project
        pythonOnBuildForHost.pkgs.setuptools
      ];
    };
}
