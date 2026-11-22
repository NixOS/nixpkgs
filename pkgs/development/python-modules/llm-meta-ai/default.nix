{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  llm,
  llm-meta-ai,
  pytest-httpx,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-meta-ai";
  version = "0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-meta-ai";
    tag = finalAttrs.version;
    hash = "sha256-DmKgm2IUxRvG6Ar6pkUVCJR2d+Hoc4kjxvGEITuDJgw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    httpx
    llm
  ];

  nativeCheckInputs = [
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_meta_ai" ];

  passthru.tests = llm.mkPluginTest llm-meta-ai;

  meta = {
    description = "LLM plugin for the Meta AI API";
    homepage = "https://github.com/simonw/llm-meta-ai";
    changelog = "https://github.com/simonw/llm-meta-ai/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
