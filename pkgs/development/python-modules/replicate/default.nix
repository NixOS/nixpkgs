{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  packaging,
  pydantic,
  typing-extensions,
  pytestCheckHook,
  pytest-asyncio,
  pytest-recording,
  respx,
}:

buildPythonPackage rec {
  pname = "replicate";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "replicate";
    repo = "replicate-python";
    rev = "refs/tags/${version}";
    hash = "sha256-q//RV4Y9k2KXXgZGfBF/XObxsBfAHE50oG+r/Vvu9BY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    packaging
    pydantic
    typing-extensions
  ];

  pythonImportsCheck = [ "replicate" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-recording
    respx
  ];

  meta = {
    description = "Python client for Replicate";
    homepage = "https://replicate.com/";
    changelog = "https://github.com/replicate/replicate-python/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
