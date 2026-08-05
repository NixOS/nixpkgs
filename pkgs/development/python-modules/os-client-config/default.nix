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
  stestrCheckHook,
  python-subunit,
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
    python-subunit
    oslotest
    stestrCheckHook
    testscenarios
    testtools
  ];

  disabledTests = [
    # assertItemsEqual removed since Python 3.12
    "os_client_config.tests.test_config.TestConfig.test_get_all_clouds"
  ];

  pythonImportsCheck = [ "os_client_config" ];

  meta = {
    description = "Unified config handling for client libraries and programs";
    homepage = "https://github.com/openstack/os-client-config";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
