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
  version = "2.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-3l7XyxKm18BAM1DhNsCmRwcZR224+8m/jQ1YHrwLHCs=";
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
