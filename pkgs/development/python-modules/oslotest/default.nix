{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  pbr,
  six,
  subunit,
  callPackage,
}:

buildPythonPackage rec {
  pname = "oslotest";
  version = "6.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j86DR3S5aGNdCIb/HgC8yyXbz+KIrFInGbFe5pvzUY4=";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    fixtures
    six
    subunit
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "oslotest" ];

  meta = {
    description = "Oslo test framework";
    homepage = "https://github.com/openstack/oslotest";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
