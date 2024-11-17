{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  torch,
}:

buildPythonPackage rec {
  pname = "curated-transformers";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "curated-transformers";
    tag = "v${version}";
    hash = "sha256-QhJZnQIa9TilwdQCUlxnQCEc6Suj669cht6WHUAr/Gw=";
  };

  build-system = [ setuptools ];

  dependencies = [ torch ];

  # Unit tests are hard to use, since most tests rely on downloading
  # models from Hugging Face Hub.
  pythonImportCheck = [ "curated_transformers" ];

  meta = with lib; {
    description = "PyTorch library of curated Transformer models and their composable components";
    homepage = "https://github.com/explosion/curated-transformers";
    changelog = "https://github.com/explosion/curated-transformers/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
