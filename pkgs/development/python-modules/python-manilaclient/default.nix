{ lib
, buildPythonApplication
, fetchPypi
, pbr
, oslo-config
, oslo-log
, oslo-serialization
, oslo-utils
, prettytable
, requests
, simplejson
, Babel
, osc-lib
, python-keystoneclient
, debtcollector
, callPackage
}:

buildPythonApplication rec {
  pname = "python-manilaclient";
  version = "3.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6iAed0mtEYHguYq4Rlh4YWT8E5hNqBYPcnG9/8RMspo=";
  };

  propagatedBuildInputs = [
    pbr
    oslo-config
    oslo-log
    oslo-serialization
    oslo-utils
    prettytable
    requests
    simplejson
    Babel
    osc-lib
    python-keystoneclient
    debtcollector
  ];

  # Checks moved to 'passthru.tests' to workaround infinite recursion
  doCheck = false;

  passthru.tests = {
    tests = callPackage ./tests.nix { };
  };

  pythonImportsCheck = [ "manilaclient" ];

  meta = with lib; {
    description = "Client library for OpenStack Manila API";
    homepage = "https://github.com/openstack/python-manilaclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
