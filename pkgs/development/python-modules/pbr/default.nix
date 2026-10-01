{
  lib,
  buildPythonPackage,
  callPackage,
  distutils,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "7.1.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Rjm4fMkdDVhHG3vaHyi30ISbpD15NcTEgvPHT+9xmAQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    distutils # for distutils.command in pbr/packaging.py
    setuptools
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
