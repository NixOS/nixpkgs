{
  lib,
  aiofiles,
  aiohttp,
  async-timeout,
  async-generator,
  buildPythonPackage,
  fetchFromGitHub,
  pypubsub,
  pyserial,
  pyserial-asyncio,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.6.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyinsteon";
    repo = "pyinsteon";
    rev = "refs/tags/${version}";
    hash = "sha256-SyhPM3NS7iJX8jwTJ4YWZ72eYLn9JT6eESekPf5eCKI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    async-timeout
    pypubsub
    pyserial
    pyserial-asyncio
    voluptuous
  ];

  nativeCheckInputs = [
    async-generator
    pytestCheckHook
  ];

  disabledTests = [
    # RuntimeError: BUG: Dead Listener called, still subscribed!
    "test_linking_with_i1_device"
  ];

  disabledTestPaths = lib.optionals (pythonAtLeast "3.12") [
    # Tests are blocking or failing
    "tests/test_handlers/"
  ];

  pythonImportsCheck = [ "pyinsteon" ];

  meta = with lib; {
    description = "Python library to support Insteon home automation projects";
    longDescription = ''
      This is a Python package to interface with an Insteon Modem. It has been
      tested to work with most USB or RS-232 serial based devices such as the
      2413U, 2412S, 2448A7 and Hub models 2242 and 2245.
    '';
    homepage = "https://github.com/pyinsteon/pyinsteon";
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "insteon_tools";
  };
}
