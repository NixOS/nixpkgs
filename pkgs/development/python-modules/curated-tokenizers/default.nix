{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  setuptools,
  regex,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "curated-tokenizers";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "curated-tokenizers";
    tag = "v${version}";
    hash = "sha256-VkDV/9c5b8TzYlthCZ38ufbrne4rihtkmkZ/gyAQXLE=";
    fetchSubmodules = true;
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [
    regex
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Explicitly set the path to avoid running vendored
  # sentencepiece tests.
  enabledTestPaths = [ "tests" ];

  preCheck = ''
    # avoid local paths, relative imports wont resolve correctly
    mv curated_tokenizers/tests tests
    rm -r curated_tokenizers
  '';

  pythonImportsCheck = [ "curated_tokenizers" ];

  meta = with lib; {
    description = "Lightweight piece tokenization library";
    homepage = "https://github.com/explosion/curated-tokenizers";
    changelog = "https://github.com/explosion/curated-tokenizers/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
