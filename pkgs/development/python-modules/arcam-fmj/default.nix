{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  attrs,
  defusedxml,
  pytest-asyncio_0,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arcam-fmj";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "arcam_fmj";
    tag = version;
    hash = "sha256-OiBTlAcSLhaMWbp5k+0yU1amSpLKnJA+3Q56lyiSDUA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    defusedxml
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytest-aiohttp
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # stuck on EpollSelector.poll()
    "test_power"
    "test_multiple"
    "test_invalid_command"
    "test_state"
    "test_silent_server_request"
    "test_silent_server_disconnect"
    "test_heartbeat"
    "test_cancellation"
    "test_unsupported_zone"
  ];

  pythonImportsCheck = [
    "arcam.fmj"
    "arcam.fmj.client"
    "arcam.fmj.state"
    "arcam.fmj.utils"
  ];

  meta = {
    description = "Python library for speaking to Arcam receivers";
    mainProgram = "arcam-fmj";
    homepage = "https://github.com/elupus/arcam_fmj";
    changelog = "https://github.com/elupus/arcam_fmj/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
