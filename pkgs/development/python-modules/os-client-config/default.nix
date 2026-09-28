{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchPypi,
  fixtures,
  jsonschema,
  openstacksdk,
  oslotest,
  pbr,
  python-glanceclient,
  setuptools,
  stestr,
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

  patches = [
    # Replace deprecated assertItemsEqual
    (fetchpatch {
      url = "https://github.com/openstack/os-client-config/commit/a72d8845545d6ac3b64b6fc48d0e2ada5750f6fe.patch";
      hash = "sha256-i8DZCdpZ8yoN0WHseczycI4iwDP55Ibzo0KLy7Moy4M=";
    })
  ];

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

  meta = {
    description = "Unified config handling for client libraries and programs";
    homepage = "https://github.com/openstack/os-client-config";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
}
