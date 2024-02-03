{ lib
, buildPythonPackage
, cliff
, fetchPypi
, iso8601
, keystoneauth1
, osc-lib
, oslo-i18n
, oslo-serialization
, oslo-utils
, pbr
, prettytable
, python-swiftclient
, pythonOlder
, pyyaml
, requests
, requests-mock
, stestr
, testscenarios
}:

buildPythonPackage rec {
  pname = "python-heatclient";
  version = "3.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ggfhDJW2qn0o4Wi5cdPsEpoHb9miZbr4Ba8mgLkStvI=";
  };

  propagatedBuildInputs = [
    cliff
    iso8601
    keystoneauth1
    osc-lib
    oslo-i18n
    oslo-serialization
    oslo-utils
    pbr
    prettytable
    python-swiftclient
    pyyaml
    requests
  ];

  nativeCheckInputs = [
    stestr
    testscenarios
    requests-mock
  ];

  checkPhase = ''
    stestr run -e <(echo "
      heatclient.tests.unit.test_common_http.HttpClientTest.test_get_system_ca_file
      heatclient.tests.unit.test_deployment_utils.TempURLSignalTest.test_create_temp_url
    ")
  '';

  pythonImportsCheck = [
    "heatclient"
  ];

  meta = with lib; {
    description = "Library for Heat built on the Heat orchestration API";
    homepage = "https://github.com/openstack/python-heatclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
