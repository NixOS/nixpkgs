{
  lib,
  buildPythonPackage,
  callPackage,
  fetchPypi,
  pbr,
  setuptools,
  six,
}:

buildPythonPackage rec {
  pname = "os-service-types";
  version = "1.8.2";
  pyproject = true;

  src = fetchPypi {
    pname = "os_service_types";
    inherit version;
    hash = "sha256-q3ZI1yMoSZQxluG7AKMOLiXmAPo7V7skHRW39SG1tXU=";
  };

  postPatch = ''
    # only a small portion of the listed packages are actually needed for running the tests
    # so instead of removing them one by one remove everything
    rm test-requirements.txt
  '';

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    pbr
    six
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "os_service_types" ];

  meta = with lib; {
    description = "Python library for consuming OpenStack service-types-authority data";
    homepage = "https://github.com/openstack/os-service-types";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
