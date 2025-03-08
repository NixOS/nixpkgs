{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  jinja2,
  numpy,
  rich,
  safetensors,
  tokenizers,
  tqdm,
  pytestCheckHook,
  scikit-learn,
  torch,
  transformers,
}:

buildPythonPackage rec {
  pname = "model2vec";
  version = "0.3.3";
  pyproject = true;

  build-system = [
    setuptools
    setuptools-scm
  ];

  src = fetchFromGitHub {
    owner = "MinishLab";
    repo = "model2vec";
    rev = "refs/tags/v${version}";
    hash = "sha256-piXpiZDOCnruHgP87dyKaqFcO6m4v8Adnkz5pw6q7+M=";
  };

  dependencies = [
    jinja2
    numpy
    rich
    safetensors
    tokenizers
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
    scikit-learn
    torch
    transformers
  ];

  pythonImportsCheck = [ "model2vec" ];

  meta = {
    description = "Fastest State-of-the-Art Static Embeddings in the World";
    homepage = "https://minishlab.github.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
