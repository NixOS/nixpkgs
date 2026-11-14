{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  cryptography,
  protobuf,
  tesla-protocol,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiopowerwall";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Teslemetry";
    repo = "aiopowerwall";
    tag = "v${finalAttrs.version}";
    hash = "sha256-be6q7Wn8OMHMPkNJSR/E4Ah0j4Clz9dj1YG4irpLqW8=";
  };

  pythonRelaxDeps = [ "tesla-protocol" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    cryptography
    protobuf
    tesla-protocol
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopowerwall" ];

  disabledTests = [
    # Disabled due to AttributeError in tesla_protocol.energy_device.transport_pb2 and typos
    "test_firmware_details_wire_format"
    "test_get_backup_events_parses_scheduled_and_manual_events"
    "test_graphql_query_wire_format"
    "test_graphql_response_without_payload_raises"
    "test_teg_api_pb2_backup_event_scheduling_fields"
    "test_transport_pb2_symbols"
  ];

  meta = {
    description = "Async Tesla Powerwall 3 client over the TEDAPI v1r RSA-signed LAN protocol";
    homepage = "https://github.com/Teslemetry/aiopowerwall";
    changelog = "https://github.com/Teslemetry/aiopowerwall/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
