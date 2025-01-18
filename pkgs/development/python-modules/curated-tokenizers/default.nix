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
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "explosion";
    repo = "curated-tokenizers";
    tag = "v${version}";
    hash = "sha256-P8kpPnaU3el7sc/vUn4waQN+JV7F9b49i6BtC4BFfIg=";
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
  pytestFlagsArray = [ "tests" ];

  preCheck = ''
    # avoid local paths, relative imports wont resolve correctly
    mv curated_tokenizers/tests tests
    rm -r curated_tokenizers
  '';

  pythonImportsCheck = [ "curated_tokenizers" ];

  meta = with lib; {
    description = "Lightweight piece tokenization library";
    homepage = "https://github.com/explosion/curated-tokenizers";
    changelog = "https://github.com/explosion/curated-tokenizers/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ danieldk ];
  };
}
