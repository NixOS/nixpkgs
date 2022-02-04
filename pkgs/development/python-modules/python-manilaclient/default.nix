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
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d53f69238cdc454c0297f513e0b481a039d0bac723990ebd5ab9d3d29633956e";
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
