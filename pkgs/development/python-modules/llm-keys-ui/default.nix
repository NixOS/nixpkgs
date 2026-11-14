{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  llm,
  llm-keys-ui,
  psutil,
  pytestCheckHook,
  starlette,
  uvicorn,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-keys-ui";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-keys-ui";
    tag = finalAttrs.version;
    hash = "sha256-RBGagIG0tSpbDv9uqY+1BXl/WgCAbJ3xyV3Wm6eCPQQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    psutil
    starlette
    uvicorn
  ];

  nativeCheckInputs = [
    httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_keys_ui" ];

  passthru.tests = llm.mkPluginTest llm-keys-ui;

  meta = {
    description = "Local web UI for managing LLM API keys";
    homepage = "https://github.com/simonw/llm-keys-ui";
    changelog = "https://github.com/simonw/llm-keys-ui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
