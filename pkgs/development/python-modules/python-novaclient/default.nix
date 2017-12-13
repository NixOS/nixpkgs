{ lib, fetchPypi, buildPythonPackage
# buildInputs
, Babel
, six
, simplejson
, prettytable
, oslo-utils
, oslo-serialization
, oslo-i18n
, iso8601
, keystoneauth1
, pbr
# checkInputs
, bandit
, coverage
, fixtures
, keyring
, mock
, keystoneclient
, cinderclient
, glanceclient
, neutronclient
, requests-mock
, sphinx
, os-client-config
, openstackdocstheme
, osprofiler
, testrepository
, testscenarios
, testtools
, tempest-lib
, reno
}:

buildPythonPackage rec {
  pname = "python-novaclient";
  version = "9.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a74k6vxylhnxpyvh5akak22618n54klg8d82r26bcpl56sc0rgf";
  };

  propagatedBuildInputs = [
    Babel
    six
    simplejson
    prettytable
    oslo-utils
    oslo-serialization
    oslo-i18n
    iso8601
    keystoneauth1
    pbr
  ];

  checkInputs = [
    bandit
    coverage
    fixtures
    keyring
    mock
    keystoneclient
    cinderclient
    glanceclient
    neutronclient
    requests-mock
    sphinx
    os-client-config
    openstackdocstheme
    osprofiler
    testrepository
    testscenarios
    testtools
    tempest-lib
    reno
  ];

  meta = with lib; {
    description = "Client library for OpenStack Compute API";
    homepage = "http://docs.openstack.org/developer/python-novaclient";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
    platforms = platforms.linux;
  };
}
