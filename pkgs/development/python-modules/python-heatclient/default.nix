{ lib
, buildPythonApplication
, fetchPypi
, pbr
, babel
, cliff
, iso8601
, osc-lib
, prettytable
, oslo-i18n
, oslo-serialization
, oslo-utils
, keystoneauth1
, python-swiftclient
, pyyaml
, requests
, six
, stestr
, testscenarios
, requests-mock
}:

buildPythonApplication rec {
  pname = "python-heatclient";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5OLysKbM2GbjMT8lshWDLMtqOrHq2DhhWvbw1oNBNZs=";
  };

  propagatedBuildInputs = [
    pbr
    babel
    cliff
    iso8601
    osc-lib
    prettytable
    oslo-i18n
    oslo-serialization
    oslo-utils
    keystoneauth1
    python-swiftclient
    pyyaml
    requests
    six
  ];

  checkInputs = [
    stestr
    testscenarios
    requests-mock
  ];

  checkPhase = ''
    stestr run -e <(echo "
      heatclient.tests.unit.test_common_http.HttpClientTest.test_get_system_ca_file
    ")
  '';

  pythonImportsCheck = [ "heatclient" ];

  meta = with lib; {
    description = "A client library for Heat built on the Heat orchestration API";
    homepage = "https://github.com/openstack/python-heatclient";
    license = licenses.asl20;
    maintainers = teams.openstack.members;
  };
}
