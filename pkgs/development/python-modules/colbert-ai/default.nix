{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  bitarray,
  datasets,
  flask,
  python-dotenv,
  ninja,
  scipy,
  tqdm,
  transformers,
  ujson,
  gitpython,
  torch,
  faiss,
}:

buildPythonPackage rec {
  pname = "colbert-ai";
  version = "0.2.22";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "colbert_ai";
    hash = "sha256-AK/P711xXw06cGvpDStbdKK7fEAgc4B861UVwAJqiIY=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    bitarray
    datasets
    faiss
    flask
    gitpython
    python-dotenv
    ninja
    scipy
    torch
    tqdm
    transformers
    ujson
  ];

  pythonImportsCheck = [ "colbert" ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "Fast and accurate retrieval model, enabling scalable BERT-based search over large text collections in tens of milliseconds";
    homepage = "https://github.com/stanford-futuredata/ColBERT";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bachp
    ];
  };
}
