{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  meteocalc,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioecowitt";
  version = "2025.3.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioecowitt";
    tag = version;
    hash = "sha256-BAiRonfu3tFf5ZERbWO+MuEsefrOIaGxUExYx5fXZIM=";
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

  meta = with lib; {
    description = "Wrapper for the EcoWitt protocol";
    mainProgram = "ecowitt-testserver";
    homepage = "https://github.com/home-assistant-libs/aioecowitt";
    changelog = "https://github.com/home-assistant-libs/aioecowitt/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
