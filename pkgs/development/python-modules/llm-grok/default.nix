{
  lib,
  callPackage,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  httpx,
  httpx-sse,
  rich,
  pytestCheckHook,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-grok";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Hiepler";
    repo = "llm-grok";
    tag = "v${version}";
    hash = "sha256-OeeU/53XKucLCtGvnl5RWc/QqF0TprB/SO8pnnK5fdw=";
  };

  build-system = [
    setuptools
    llm
  ];

  dependencies = [
    httpx
    httpx-sse
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_grok" ];

  passthru.tests = {
    llm-plugin = callPackage ./tests/llm-plugin.nix { };
  };

  meta = {
    description = "LLM plugin providing access to Grok models using the xAI API";
    homepage = "https://github.com/Hiepler/llm-grok";
    changelog = "https://github.com/Hiepler/llm-grok/releases/tag/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
