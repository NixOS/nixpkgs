{
  lib,
  aiohttp,
  asyncio-dgram,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  frozenlist,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  voluptuous,
  typing-extensions,
  yarl,
}:

buildPythonPackage rec {
  pname = "aioguardian";
  version = "2025.02.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioguardian";
    tag = version;
    hash = "sha256-RoVD2O/OAk4l96kYEq7ZM/2QuckcPxDluf1MT4HdKc4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry-core==2.0.1 poetry-core
  '';

  pythonRelaxDeps = [
    "asyncio_dgram"
    "frozenlist"
    "typing-extensions"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    asyncio-dgram
    certifi
    frozenlist
    voluptuous
    typing-extensions
    yarl
  ];

  nativeCheckInputs = [
    asyncio-dgram
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "aioguardian" ];

  meta = with lib; {
    description = "Python library to interact with Elexa Guardian devices";
    longDescription = ''
      aioguardian is an asyncio-focused library for interacting with the
      Guardian line of water valves and sensors from Elexa.
    '';
    homepage = "https://github.com/bachya/aioguardian";
    changelog = "https://github.com/bachya/aioguardian/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
