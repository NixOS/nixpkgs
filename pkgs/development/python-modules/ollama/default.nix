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
  version = "0.4.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ollama";
    repo = "ollama-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-GW/4adrU6/4cM96U6A8Btgv7Qt1jtSFJr9F8+zwTEpk=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "0.0.0" "${version}"
  '';

  pythonRelaxDeps = [ "httpx" ];

  build-system = [ poetry-core ];

  dependencies = [ httpx ];

  nativeCheckInputs = [
    pillow
    pydantic
    pytest-asyncio
    pytest-httpserver
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ollama" ];

  meta = with lib; {
    description = "Ollama Python library";
    homepage = "https://github.com/ollama/ollama-python";
    changelog = "https://github.com/ollama/ollama-python/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
