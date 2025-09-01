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
  version = "5.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WpRA0o2MywC89f56BWkEF+pilDsMjpOkMX2LG9Au6O4=";
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
