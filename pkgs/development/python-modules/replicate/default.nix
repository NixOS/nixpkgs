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
  version = "1.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "replicate";
    repo = "replicate-python";
    tag = version;
    hash = "sha256-zl7b6zg5igyFvx5Qw0cjIiY25xivpTucc2NcP1IkFUI=";
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
    changelog = "https://github.com/replicate/replicate-python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jokatzke ];
  };
}
