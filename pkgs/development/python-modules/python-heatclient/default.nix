{
  lib,
  buildPythonPackage,
  cliff,
  fetchPypi,
  iso8601,
  keystoneauth1,
  openstackdocstheme,
  osc-lib,
  oslo-i18n,
  oslo-serialization,
  oslo-utils,
  pbr,
  prettytable,
  python-openstackclient,
  python-swiftclient,
  pyyaml,
  requests-mock,
  requests,
  setuptools,
  sphinxHook,
  stestr,
  testscenarios,
}:

buildPythonPackage rec {
  pname = "python-heatclient";
  version = "5.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "python_heatclient";
    inherit version;
    hash = "sha256-q3CtG+bRPo9gNHl6KJSutDU33EKUun/7C0pBe1ahpx4=";
  };

  build-system = [
    openstackdocstheme
    python-openstackclient
    setuptools
    sphinxHook
  ];

  sphinxBuilders = [ "man" ];

  dependencies = [
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
    runHook preCheck

    stestr run -e <(echo "
      heatclient.tests.unit.test_common_http.HttpClientTest.test_get_system_ca_file
      heatclient.tests.unit.test_deployment_utils.TempURLSignalTest.test_create_temp_url
    ")

    runHook postCheck
  '';

  pythonImportsCheck = [ "heatclient" ];

  meta = {
    description = "Library for Heat built on the Heat orchestration API";
    mainProgram = "heat";
    homepage = "https://github.com/openstack/python-heatclient";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
