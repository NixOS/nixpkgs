{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  llm,
  openai,

  # tests
  pytestCheckHook,
  pytest-recording,
  writableTmpDirAsHomeHook,
  llm-perplexity,
}:
buildPythonPackage rec {
  pname = "llm-perplexity";
  version = "2026.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex";
    repo = "llm-perplexity";
    tag = version;
    hash = "sha256-fHR67oaDSuTkRIpUrnLFuoHr1YZcikFEcq+8RmgVxnE=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-recording
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_perplexity" ];

  passthru.tests = llm.mkPluginTest llm-perplexity;

  meta = {
    description = "LLM access to pplx-api";
    homepage = "https://github.com/hex/llm-perplexity";
    changelog = "https://github.com/hex/llm-perplexity/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jed-richards ];
  };
}
