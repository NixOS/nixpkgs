{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx2-pytest,
  llm,
  llm-mistral,
  mistralai,
  pytestCheckHook,
  pytest-asyncio,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-mistral";
  version = "0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-mistral";
    tag = version;
    hash = "sha256-I625+DNJxsqRzCGxb069d/AAqDxz49w7ifQPUx25ktA=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    llm
    mistralai
  ];

  nativeCheckInputs = [
    httpx2-pytest
    pytestCheckHook
    pytest-asyncio
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_mistral" ];

  passthru.tests = llm.mkPluginTest llm-mistral;

  meta = {
    description = "LLM plugin providing access to Mistral models using the Mistral API";
    homepage = "https://github.com/simonw/llm-mistral";
    changelog = "https://github.com/simonw/llm-mistral/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
