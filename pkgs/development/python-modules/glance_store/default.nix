{ lib, buildPythonPackage, fetchPypi
, jsonschema
, oslo-config
, oslo-i18n
, oslo-serialization
, oslo-utils
, oslo-concurrency
, stevedore
, mock
, fixtures
, subunit
, requests-mock
, testrepository
, testscenarios
, testtools
, oslotest
, oslosphinx
, boto
, oslo-vmware
}:

buildPythonPackage rec {
  pname = "glance_store";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16az3lq9szl0ixna9rd82dmn4sfxqyivhn4z3z79vk8qdfip1sr9";
  };

  patches = [
      ./fix_swiftclient_mocking.patch
  ];

  propagatedBuildInputs = [
    jsonschema
    oslo-config
    oslo-i18n
    oslo-serialization
    oslo-utils
    oslo-concurrency
    stevedore
  ];


  checkInputs = [
    mock
    fixtures
    subunit
    requests-mock
    testrepository
    testscenarios
    testtools
    oslotest
    oslosphinx
    boto
    oslo-vmware
  ];

  # greenlet socket.getprotobyname error
  doCheck = false;

  meta = with lib; {
    description = "Glance Store Library";
    homepage = "http://www.openstack.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ makefu ];
  };

}
