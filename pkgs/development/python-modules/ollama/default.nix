{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  pillow,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "ollama";
  version = "0.4.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama-python";
    tag = "v${version}";
    hash = "sha256-ZhSbd7Um3+jG3yL3FwCm0lUdi5EQXVjJk0UMLRKeLOQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  pythonRelaxDeps = [ "httpx" ];

  build-system = [ poetry-core ];

  dependencies = [
    httpx
    pydantic
  ];

  nativeCheckInputs = [
    pillow
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ollama" ];

  meta = with lib; {
    description = "Ollama Python library";
    homepage = "https://github.com/ollama/ollama-python";
    changelog = "https://github.com/ollama/ollama-python/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
