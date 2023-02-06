{ lib
, buildPythonPackage
, fetchPypi

  # REQUIRED DEPENDENCIES:
, datasets
, dill
, fsspec
, huggingface-hub
, importlib-metadata
, multiprocess
, numpy
, packaging
, pandas
, requests
, responses
, tqdm
, xxhash

  # EVERYTHING THAT FOLLOWS ARE CHECK DEPENDENCIES:
, pytestCheckHook

  # test dependencies
, absl-py
, cer # for characTER
, charcut # for charcut_mt
, nltk # for NIST and probably others
, pytest-datadir
, pytest-xdist

  # optional dependencies
, tensorflow
, torch

  # metrics dependencies
  # , bert_score
  # , jiwer
  # , mauve-text
  # , rouge_score
  # , sacrebleu
, sacremoses
, scikit-learn
, scipy
, sentencepiece # for bleurt
, seqeval
, transformers # for evaluator
, trectools

  # to speed up pip backtracking
, requests-file
, six
, texttable
, tldextract
, toml
, unidecode
, werkzeug
}:

buildPythonPackage
rec {
  pname = "evaluate";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vWpZh5vprhO2gWhOVq4+bqZXBzxEE7MDNenvqYVuT0Q=";
  };

  propagatedBuildInputs = [
    datasets
    dill
    fsspec
    huggingface-hub
    importlib-metadata
    multiprocess
    numpy
    packaging
    pandas
    requests
    responses
    tqdm
    xxhash
  ];

  nativeCheckInputs = [
    pytestCheckHook

    # test dependencies
    absl-py
    cer # for characTER
    charcut # for charcut_mt
    nltk # for NIST and probably others
    pytest-datadir
    pytest-xdist

    # optional dependencies
    tensorflow
    torch

    # metrics dependencies
    # bert_score
    # jiwer
    # mauve-text
    # rouge_score
    # sacrebleu
    sacremoses
    scikit-learn
    scipy
    sentencepiece # for bleurt
    seqeval
    transformers # for evaluator
    trectools

    # to speed up pip backtracking
    requests-file
    six
    texttable
    tldextract
    toml
    unidecode
    werkzeug
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "responses<0.19" "responses"
      # As of 2023-02-05, nixpkgs responses==0.22.0
  '';

  pythonImportsCheck = [
    "evaluate"
  ];

  meta = with lib; {
    description = "A library for easily evaluating machine learning models and datasets";
    homepage = "https://github.com/huggingface/evaluate";
    license = licenses.asl20;
    maintainers = with maintainers; [ YodaEmbedding ];
  };
}
