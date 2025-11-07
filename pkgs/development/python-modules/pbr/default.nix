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
  version = "7.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PsvLEdK4VRWI7IFrN1ax60OUGGw7aJsX4EhQ38IPflc=";
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

  meta = with lib; {
    description = "Python Build Reasonableness";
    mainProgram = "pbr";
    homepage = "https://github.com/openstack/pbr";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
