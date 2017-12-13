{ lib, fetchPypi, buildPythonPackage
# buildInputs
, stevedore
, six
, simplejson
, pbr
, oslo-utils
, oslo-i18n
, os-client-config
, keystoneauth1
, cliff
, Babel
# checkInputs
, coverage
, fixtures
, mock
, oslotest
, requests-mock
, sphinx
, os-testr
, testrepository
, testtools
, osprofiler
, bandit
, openstackdocstheme
, reno
}:

# osc-lib = callPackage ../development/python-modules/osc-lib {};
buildPythonPackage rec {
  pname = "osc-lib";
  version = "1.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y7c26fh48wyrjxhiz3qwkax97mr36h7y9inv39zhy2l7vqp5vkx";
  };

  propagatedBuildInputs = [
    stevedore
    six
    simplejson
    pbr
    oslo-utils
    oslo-i18n
    os-client-config
    keystoneauth1
    cliff
    Babel
  ];

  checkInputs = [
    coverage
    fixtures
    mock
    oslotest
    requests-mock
    sphinx
    os-testr
    testrepository
    testtools
    osprofiler
    bandit
    openstackdocstheme
    reno
  ];

  meta = with lib; {
    description = "OpenStackClient Library";
    homepage = "http://docs.openstack.org/developer/osc-lib";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
