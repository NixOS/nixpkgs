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
  writableTmpDirAsHomeHook,
  python-dotenv,
  pillow,
  llm-perplexity,
}:
buildPythonPackage rec {
  pname = "llm-perplexity";
  version = "2025.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hex";
    repo = "llm-perplexity";
    tag = version;
    hash = "sha256-LTf2TY5bjSb7ARXrhWj1ctGuMpnq2Kl/kv/hrgX/m/M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    llm
    openai
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    python-dotenv
    pillow
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
