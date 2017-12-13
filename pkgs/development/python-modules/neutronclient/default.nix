{ lib, fetchPypi, buildPythonPackage
# buildInputs
, Babel
, six
, simplejson
, requests
, keystoneclient
, keystoneauth1
, os-client-config
, oslo-utils
, oslo-serialization
, oslo-i18n
, osc-lib
, netaddr
, iso8601
, debtcollector
, cliff
, pbr
# checkInputs
, tempest-lib
, mox3
, oslotest
, requests-mock
, osprofiler
}:

buildPythonPackage rec {
  pname = "python-neutronclient";
  version = "6.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02pnd6k847wfm6y6hx6ync46xx6ay5c55775jrjvnfhkbn8yvkam";
  };

  propagatedBuildInputs = [
    Babel
    six
    simplejson
    requests
    keystoneclient
    keystoneauth1
    os-client-config
    oslo-utils
    oslo-serialization
    oslo-i18n
    osc-lib
    netaddr
    iso8601
    debtcollector
    cliff
    pbr
  ];

  checkInputs = [
    tempest-lib
    mox3
    oslotest
    requests-mock
    osprofiler
  ];

  meta = with lib; {
    description = "CLI and Client Library for OpenStack Networking";
    homepage = "https://docs.openstack.org/python-neutronclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
