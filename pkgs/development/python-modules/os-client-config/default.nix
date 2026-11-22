{
  lib,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
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

buildPythonPackage (finalAttrs: {
  pname = "os-client-config";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openstack";
    repo = "os-client-config";
    tag = finalAttrs.version;
    hash = "sha256-nVaL5w3ZrBTxK0BBNYjpr7Ssb9Wa3qO3jjW84oB553I=";
  };

  # Manually set version since pbr wants to get it from git (not in a tarball)
  env.PBR_VERSION = finalAttrs.version;

  patches = [
    # Replace deprecated assertItemsEqual
    (fetchpatch {
      url = "https://github.com/openstack/os-client-config/commit/a72d8845545d6ac3b64b6fc48d0e2ada5750f6fe.patch";
      hash = "sha256-i8DZCdpZ8yoN0WHseczycI4iwDP55Ibzo0KLy7Moy4M=";
    })
  ];

  postPatch = ''
    # pbr needs git to ship subpackages and package data
    echo "recursive-include os_client_config *" > MANIFEST.in
  '';

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

  pythonImportsCheck = [ "os_client_config" ];

  meta = {
    description = "Unified config handling for client libraries and programs";
    homepage = "https://github.com/openstack/os-client-config";
    license = lib.licenses.asl20;
    teams = [ lib.teams.openstack ];
  };
})
