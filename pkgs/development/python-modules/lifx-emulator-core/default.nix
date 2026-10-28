{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  stdenv,
  writableTmpDirAsHomeHook,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "lifx-emulator-core";
  version = "3.12.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "lifx-emulator";
    tag = "core-v${finalAttrs.version}";
    hash = "sha256-Asb/n37gU1RqinqtVvbOAu4GHZmEbkkdzg2DmyFuHLo=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/lifx-emulator-core";

  build-system = [ hatchling ];

  dependencies = [
    pydantic
    pyyaml
    zeroconf
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # mdns is not supported in Darwin build sandbox
    "tests/test_mdns_config.py::test_mdns_mixed_records"
    "tests/test_mdns_lifecycle.py::test_membership_add_remove_readd_wire"
    "tests/test_mdns_responder.py::test_default_record_sets"
    "tests/test_mdns_responder.py::test_tracer_legacy_unicast"
    "tests/test_mdns_review.py::test_readd_after_wire_ttl_with_delayed_self_cached_ptr"
  ];

  pythonImportsCheck = [ "lifx_emulator" ];

  meta = {
    description = "Core Python library for emulating LIFX devices using the LAN protocol";
    homepage = "https://github.com/Djelibeybi/lifx-emulator/tree/main/packages/lifx-emulator-core";
    license = lib.licenses.upl;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
