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
  pyserial-asyncio-fast,
  pytestCheckHook,
  pythonAtLeast,
  setuptools,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pyinsteon";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyinsteon";
    repo = "pyinsteon";
    tag = version;
    hash = "sha256-iC0qeiTHtrdzQtJ3R01nJDCfdBKBg0jw1v49ZII24/4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiofiles
    aiohttp
    async-timeout
    pypubsub
    pyserial
    pyserial-asyncio-fast
    voluptuous
  ];

  nativeCheckInputs = [
    async-generator
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyinsteon" ];

  meta = {
    description = "Python library to support Insteon home automation projects";
    longDescription = ''
      This is a Python package to interface with an Insteon Modem. It has been
      tested to work with most USB or RS-232 serial based devices such as the
      2413U, 2412S, 2448A7 and Hub models 2242 and 2245.
    '';
    homepage = "https://github.com/pyinsteon/pyinsteon";
    changelog = "https://github.com/pyinsteon/pyinsteon/releases/tag/${version}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "insteon_tools";
  };
}
