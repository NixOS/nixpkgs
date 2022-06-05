{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, callPackage
}:

buildPythonPackage rec {
  pname = "pbr";
  version = "5.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ZrxaNJEvQIuzklvyEjHLb1kgYme39j81A++GXBopLiU=";
  };

  propagatedBuildInputs = [ setuptools ];

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
    maintainers = teams.openstack.members;
  };
}
