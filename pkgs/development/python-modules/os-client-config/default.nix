{
  lib,
  buildPythonPackage,
  fetchPypi,
  fixtures,
  jsonschema,
  openstacksdk,
  oslotest,
  pbr,
  python-glanceclient,
  setuptools,
  stestr,
  subunit,
  testscenarios,
  testtools,
}:

buildPythonPackage rec {
  pname = "os-client-config";
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "os_client_config";
    inherit version;
    hash = "sha256-4WomDy/VAK8U8Ve5t7fWkpLOg7D4pGHsaM5qikKWfL0=";
  };

  build-system = [
    pbr
    setuptools
  ];

  dependencies = [
    openstacksdk
    pbr
    python-glanceclient
  ];

  nativeCheckInputs = [
    fixtures
    jsonschema
    subunit
    oslotest
    stestr
    testscenarios
    testtools
  ];

  checkPhase = ''
    runHook preCheck

    stestr run

    runHook postCheck
  '';

  pythonImportsCheck = [ "os_client_config" ];

  meta = with lib; {
    description = "Unified config handling for client libraries and programs";
    homepage = "https://github.com/openstack/os-client-config";
    license = licenses.asl20;
    teams = [ teams.openstack ];
  };
}
