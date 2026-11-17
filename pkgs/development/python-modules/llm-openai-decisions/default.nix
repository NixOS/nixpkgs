{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  httpx2,
  httpx2-pytest,
  llm,
  llm-openai-decisions,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-openai-decisions";
  version = "0.1";
  pyproject = true;

  # The 0.1 release has no matching tag upstream; the sdist includes the tests.
  src = fetchPypi {
    pname = "llm_openai_decisions";
    inherit (finalAttrs) version;
    hash = "sha256-3/tf8OCuPUUfWk4OPhEkgn2szNGMd3Z11y/GGhiic54=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx2
    llm
    pydantic
  ];

  nativeCheckInputs = [
    httpx2-pytest
    pytest-asyncio
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_openai_decisions" ];

  passthru.tests = llm.mkPluginTest llm-openai-decisions;

  meta = {
    description = "LLM plugin for the OpenAI Decisions API";
    homepage = "https://github.com/simonw/llm-openai-decisions";
    changelog = "https://github.com/simonw/llm-openai-decisions/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
