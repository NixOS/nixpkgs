{ lib
, aiofiles
, aiohttp
, async-generator
, buildPythonPackage
, fetchFromGitHub
, pypubsub
, pyserial
, pyserial-asyncio
, pytestCheckHook
, pythonAtLeast
, pythonOlder
, setuptools
, voluptuous
, wheel
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.5.3";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-9d6QbekUv63sjKdK+ZogYOkGfFXVW+JB6ITHnehLwtM=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiofiles
    aiohttp
    pypubsub
    pyserial
    pyserial-asyncio
    voluptuous
  ];

  nativeCheckInputs = [
    async-generator
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # AssertionError: Failed test 'read_eeprom_response' with argument 'group' value X vs expected value Z
    "test_async_send"
    "test_nak_response"
    "test_no_direct_ack"
    "test_on_level"
    "test_on_level_group"
    "test_on_level_nak"
    # AssertionError: Failed test 'read_eeprom_response' with argument 'target' value X vs expected value Y
    "test_other_status"
    "test_status_command"
    "test_status_request_hub"
    # stuck in epoll
    "test_read_all_peek"
  ];

  pythonImportsCheck = [
    "pyinsteon"
  ];

  meta = with lib; {
    description = "Python library to support Insteon home automation projects";
    mainProgram = "insteon_tools";
    longDescription = ''
      This is a Python package to interface with an Insteon Modem. It has been
      tested to work with most USB or RS-232 serial based devices such as the
      2413U, 2412S, 2448A7 and Hub models 2242 and 2245.
    '';
    homepage = "https://github.com/pyinsteon/pyinsteon";
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
