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
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "replicate";
    repo = "replicate-python";
    rev = "refs/tags/${version}";
    hash = "sha256-VXJBArFzVPls0ZWL8o6hkOiTtjYRxkdNDiWCPN/hW48=";
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
