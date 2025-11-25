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
  version = "6.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-CHBKOnoEtZtQAu5YTFPKlYn0VU/hAA5nbs4wwZVHgj4=";
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

  meta = with lib; {
    description = "Oslo test framework";
    homepage = "https://github.com/openstack/oslotest";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
