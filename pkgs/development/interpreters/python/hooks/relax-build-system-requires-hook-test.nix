{ pythonOnBuildForHost, runCommand }:
let
  # pyproject.toml which has unnecessary version constraints in build-system.requires
  pyprojectToml = builtins.toFile "pyproject.toml" ''
    [project]
    name = "relax-build-system-requires-hook-test"
    version = "1.0.0"
    [build-system]
    requires = ["setuptools==0.0.0", 'name[foo]>=2,<3; python_version>"2.0"']
  '';
  # the source of the example project
  projectSource = runCommand "my-project-source" { } ''
    mkdir -p $out/src
    cp ${pyprojectToml} $out/pyproject.toml
    touch $out/src/__init__.py
  '';
in
pythonOnBuildForHost.pkgs.buildPythonPackage {
  pname = "relax-build-system-requires-hook-test";
  version = "1.0.0";
  pyproject = true;

  src = projectSource;

  build-system = [ pythonOnBuildForHost.pkgs.setuptools ];
  relaxBuildSystem = [ "setuptools" ];
  removeBuildSystem = [ "name" ];
}
