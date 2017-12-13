{ lib, fetchPypi, buildPythonPackage
# buildInputs
, six
, requests
, pbr
, oslo-utils
, oslo-serialization
, oslo-i18n
, keystoneauth1
, cliff
# checkInputs
, fixtures
, requests-mock
, mock
, testrepository
, testtools
, oslotest
, nose
, oslo-config
, openstackclient
, sphinx
, openstackdocstheme
}:

buildPythonPackage rec {
  pname = "python-barbicanclient";
  version = "4.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1xpnrlnvgq1b9pvsp7wnyqcs29yw9rb34i42fnaqlrxdh547w05k";
  };

  propagatedBuildInputs = [
    six
    requests
    pbr
    oslo-utils
    oslo-serialization
    oslo-i18n
    keystoneauth1
    cliff
  ];

  # openstackclient has broken dependencies
  doCheck = false;
  checkInputs = [
    fixtures
    requests-mock
    mock
    testrepository
    testtools
    oslotest
    nose
    oslo-config
    openstackclient
    sphinx
    openstackdocstheme
  ];

  postPatch = ''
    sed -i /hacking/d test-requirements.txt
  '';

  meta = with lib; {
    description = "Client Library for OpenStack Barbican Key Management API";
    homepage = "https://docs.openstack.org/python-barbicanclient/latest/";
    license = licenses.asl20;
    maintainers = with maintainers; [  ];
  };
}
