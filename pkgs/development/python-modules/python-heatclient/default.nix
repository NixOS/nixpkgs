{ lib
, buildPythonApplication
, fetchPypi
, pbr
, Babel
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
  version = "2.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b610748eb3f18f6bd762e0808accdf872308289a77c3b19ed2d8b9f306393a42";
  };

  propagatedBuildInputs = [
    pbr
    Babel
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
