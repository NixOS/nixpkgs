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
  pythonOlder,
  websockets,
  yarl,
}:

buildPythonPackage rec {
  pname = "aioambient";
  version = "2025.02.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "bachya";
    repo = "aioambient";
    tag = version;
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

  meta = with lib; {
    description = "Python library for the Ambient Weather API";
    homepage = "https://github.com/bachya/aioambient";
    changelog = "https://github.com/bachya/aioambient/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
