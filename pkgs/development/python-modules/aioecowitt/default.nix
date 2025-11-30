{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  meteocalc,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioecowitt";
  version = "2025.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioecowitt";
    tag = version;
    hash = "sha256-lQ2t8u3+sk8wnNfCZs2yhe9nsZwiGBHXPDz95egacsI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    meteocalc
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioecowitt" ];

  meta = {
    description = "Wrapper for the EcoWitt protocol";
    homepage = "https://github.com/home-assistant-libs/aioecowitt";
    changelog = "https://github.com/home-assistant-libs/aioecowitt/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
