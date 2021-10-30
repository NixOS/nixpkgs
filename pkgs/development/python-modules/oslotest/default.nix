{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, pbr
, subunit
, callPackage
}:

buildPythonPackage rec {
  pname = "oslotest";
  version = "4.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "360ad2c41ba3ad6f059c7c6e7291450d082c2e5dbb0012e839a829978053dfe6";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [
    fixtures
    subunit
  ];

  # check in passthru.tests.pytest to escape infinite recursion with other oslo components
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix {};
  };

  pythonImportsCheck = [ "oslotest" ];

  meta = with lib; {
    description = "Oslo test framework";
    homepage = "https://github.com/openstack/oslotest";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
