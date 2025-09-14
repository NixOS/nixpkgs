{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  meteocalc,
  pytest-asyncio_0,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioecowitt";
  version = "2025.9.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioecowitt";
    tag = version;
    hash = "sha256-NLVxQ7xQJiI0G9MXuVK+dWSYbA9AS7NAEEOBSCCQI88=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    meteocalc
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    (pytest-aiohttp.override { pytest-asyncio = pytest-asyncio_0; })
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioecowitt" ];

  meta = with lib; {
    description = "Wrapper for the EcoWitt protocol";
    mainProgram = "ecowitt-testserver";
    homepage = "https://github.com/home-assistant-libs/aioecowitt";
    changelog = "https://github.com/home-assistant-libs/aioecowitt/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
