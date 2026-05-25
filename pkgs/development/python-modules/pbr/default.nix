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
  version = "7.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tGAE7DClMkZyaD7ISK7Z6PxQCw0mHUCjIpwtK7/O3Ck=";
  };

  build-system = [ setuptools ];

  dependencies = [
    distutils # for distutils.command in pbr/packaging.py
    setuptools # for pkg_resources
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
