{
  lib,
  buildPythonPackage,
  callPackage,
  distutils,
  fetchPypi,
  setuptools_80,
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "7.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lz2irumWHXyyeKp04YKfbar+yd2O6MFlXL8/WEO/4IM=";
  };

  build-system = [ setuptools_80 ];

  dependencies = [
    distutils # for distutils.command in pbr/packaging.py
    setuptools_80 # for pkg_resources
  ];

  # check in passthru.tests.pytest to escape infinite recursion with fixtures
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "pbr" ];

  meta = {
    description = "Python Build Reasonableness";
    mainProgram = "pbr";
    homepage = "https://github.com/openstack/pbr";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
