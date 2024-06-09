{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  attrs,
  defusedxml,
  pytest-aiohttp,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "arcam-fmj";
  version = "1.5.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "arcam_fmj";
    rev = "refs/tags/${version}";
    hash = "sha256-hBoUxY+xtW04UPUG2P8A8QQbHxGk0bjcrtXis6nlaGg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
    defusedxml
  ];

  nativeCheckInputs = [
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

  meta = with lib; {
    description = "Python library for speaking to Arcam receivers";
    mainProgram = "arcam-fmj";
    homepage = "https://github.com/elupus/arcam_fmj";
    changelog = "https://github.com/elupus/arcam_fmj/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
