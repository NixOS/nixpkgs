{ lib
, buildPythonPackage
, fetchPypi
, pythonAtLeast
, setuptools
, callPackage
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0TdxIqWgDi+UDuSCmZUY7+FtdF1COmcMJ3c9+8PJp9k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # check in passthru.tests.pytest to escape infinite recursion with fixtures
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "pbr" ];

  meta = with lib; {
    description = "Python Build Reasonableness";
    homepage = "https://github.com/openstack/pbr";
    license = licenses.asl20;
    broken = pythonAtLeast "3.12"; # uses removed distutils
    maintainers = teams.openstack.members;
  };
}
