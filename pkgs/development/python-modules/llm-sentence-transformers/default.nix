{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  llm,
  llm-sentence-transformers,
  einops,
  sentence-transformers,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-sentence-transformers";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-sentence-transformers";
    tag = version;
    hash = "sha256-FDDMItKFEYEptiL3EHKgKVxClqRU9RaM3uD3xP0F4OM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    einops
    llm
    sentence-transformers
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Disabled because they access the network
  disabledTests = [
    "test_run_embedding"
    "test_embed_multi_with_generator"
  ];

  pythonImportsCheck = [ "llm_sentence_transformers" ];

  passthru.tests = llm.mkPluginTest llm-sentence-transformers;

  meta = {
    description = "LLM plugin for embeddings using sentence-transformers";
    homepage = "https://github.com/simonw/llm-sentence-transformers";
    changelog = "https://github.com/simonw/llm-sentence-transformers/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
