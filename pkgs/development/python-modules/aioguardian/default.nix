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
  voluptuous,
  typing-extensions,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioguardian";
  version = "2026.01.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioguardian";
    tag = finalAttrs.version;
    hash = "sha256-55jMGJ4pRMjvSAYsXIclzzMcz+PqS/334Fd7hoY8YTk=";
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

  meta = {
    description = "Python library to interact with Elexa Guardian devices";
    longDescription = ''
      aioguardian is an asyncio-focused library for interacting with the
      Guardian line of water valves and sensors from Elexa.
    '';
    homepage = "https://github.com/bachya/aioguardian";
    changelog = "https://github.com/bachya/aioguardian/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
