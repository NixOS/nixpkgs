{ lib
, buildPythonPackage
, fetchPypi
, fixtures
, pbr
, six
, subunit
, callPackage
}:

buildPythonPackage rec {
  pname = "oslotest";
  version = "5.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-97skDGy+8voLq7lRP/PafQ8ozDja+Y70Oy6ISDZ/vSA=";
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
