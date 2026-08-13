{
  lib,
  buildPythonPackage,
  catalogue,
  curated-tokenizers,
  fetchFromGitHub,
  huggingface-hub,
  setuptools,
  tokenizers,
  torch,
}:

buildPythonPackage rec {
  pname = "curated-transformers";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "curated-transformers";
    tag = "v${version}";
    hash = "sha256-2sedBVpwCppviWix+d3tJFTrLBe+2IBlWnCKgV6MucA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    catalogue
    curated-tokenizers
    huggingface-hub
    tokenizers
    torch
  ];

  # Unit tests are hard to use, since most tests rely on downloading
  # models from Hugging Face Hub.
  pythonImportsCheck = [ "curated_transformers" ];

  meta = {
    description = "PyTorch library of curated Transformer models and their composable components";
    homepage = "https://github.com/explosion/curated-transformers";
    changelog = "https://github.com/explosion/curated-transformers/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ danieldk ];
  };
}
