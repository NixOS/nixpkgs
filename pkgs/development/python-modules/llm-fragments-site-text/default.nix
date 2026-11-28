{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  llm,
  llm-fragments-site-text,
  pytest-httpx,
  pytestCheckHook,
  trafilatura,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "llm-fragments-site-text";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "daturkel";
    repo = "llm-fragments-site-text";
    tag = finalAttrs.version;
    hash = "sha256-JzD72tMd3wIK6TeQ60LCB4DsIMCpF/zqPbqbzjVNYB0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    # Imported directly but not declared upstream.
    httpx
    llm
    trafilatura
  ];

  nativeCheckInputs = [
    pytest-httpx
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_fragments_site_text" ];

  passthru.tests = llm.mkPluginTest llm-fragments-site-text;

  meta = {
    description = "LLM fragment loader that runs URLs through Trafilatura to get plain text";
    homepage = "https://github.com/daturkel/llm-fragments-site-text";
    changelog = "https://github.com/daturkel/llm-fragments-site-text/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
})
