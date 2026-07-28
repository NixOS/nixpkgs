{
  lib,
  aiohttp,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-mystrom";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-ecosystem";
    repo = "python-mystrom";
    tag = finalAttrs.version;
    hash = "sha256-zg/t2EQ6h8fThbV3U1h3Bs9pxOmlswicR3dREoQuuoY=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    click
    requests
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pymystrom.bulb"
    "pymystrom.pir"
    "pymystrom.switch"
  ];

  meta = {
    description = "Python API client for interacting with myStrom devices";
    longDescription = ''
      Asynchronous Python API client for interacting with myStrom devices.
      There is support for bulbs, motion sensors, plugs and buttons.
    '';
    homepage = "https://github.com/home-assistant-ecosystem/python-mystrom";
    changelog = "https://github.com/home-assistant-ecosystem/python-mystrom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mystrom";
  };
})
