{
  lib,
  buildPythonPackage,
  callPackage,
  distutils,
  fetchPypi,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "6.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k+pyzmmJ6y7tmdD3VyFHT2mtiBKK/e9aw3freXxL92s=";
  };

  build-system = [ setuptools ];

  dependencies = [
    distutils # for distutils.command in pbr/packaging.py
    setuptools # for pkg_resources
    six
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
