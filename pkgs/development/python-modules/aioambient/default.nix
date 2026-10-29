{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  poetry-core,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  python-engineio,
  python-socketio,
  websockets,
  yarl,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioambient";
  version = "2025.02.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioambient";
    tag = finalAttrs.version;
    hash = "sha256-F1c2S0c/CWHeCd24Zc8ib3aPR7yj9gCPBJpmpgoddQY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail poetry-core==2.0.1 poetry-core
  '';

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    certifi
    python-engineio
    python-socketio
    websockets
    yarl
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    aresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
  ];

  # Ignore the examples directory as the files are prefixed with test_
  disabledTestPaths = [ "examples/" ];

  pythonImportsCheck = [ "aioambient" ];

  meta = {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    changelog = "https://github.com/bachya/aioambient/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
