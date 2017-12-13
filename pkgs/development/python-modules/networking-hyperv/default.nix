{ lib, fetchPypi, buildPythonPackage
, neutronclient
, pbr
, oslo-utils
, oslo-serialization
, oslo-log
, oslo-i18n
, neutron-lib
, eventlet
, Babel
, coverage
, ddt
, fixtures
, mock
, docutils
, sphinx
, oslo-config
, oslotest
, testrepository
, testscenarios
, testtools
, openstackdocstheme
, reno
}:

buildPythonPackage rec {
  pname = "networking-hyperv";
  version = "5.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0y308hvyrdf3hdixrz94j3hns02ism4l3mjikyx78035i2xa4swn";
  };

  propagatedBuildInputs = [
    neutronclient
    pbr
    oslo-utils
    oslo-serialization
    oslo-log
    oslo-i18n
    oslo-config
    neutron-lib
    eventlet
    Babel
  ];

  checkInputs = [
    coverage
    ddt
    fixtures
    mock
    docutils
    sphinx
    oslo-config
    oslotest
    testrepository
    testscenarios
    testtools
    openstackdocstheme
    reno
  ];

  meta = with lib; {
    description = "This project tracks the work to integrate the Hyper-V networking with Neutron";
    homepage = "https://github.com/openstack/networking-hyperv";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
