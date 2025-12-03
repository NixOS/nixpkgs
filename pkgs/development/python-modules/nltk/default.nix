{
  lib,
  pkgs,
  fetchPypi,
  buildPythonPackage,
  pythonOlder,
  click,
  joblib,
  regex,
  tqdm,

  # preInstallCheck
  nltk,

  # nativeCheckInputs
  matplotlib,
  numpy,
  pyparsing,
  pytestCheckHook,
  pytest-mock,
}:

buildPythonPackage rec {
  pname = "nltk";
  version = "3.9.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D0CemwacpBd8GQPD6EPu+Qx+kpkvpJMa5gfabeSeFBk=";
  };

  dependencies = [
    click
    joblib
    regex
    tqdm
  ];

  # Use new passthru function to pass dependencies required for testing
  preInstallCheck = ''
    export NLTK_DATA=${
      nltk.dataDir (
        d: with d; [
          averaged-perceptron-tagger-eng
          averaged-perceptron-tagger-rus
          brown
          cess-cat
          cess-esp
          conll2007
          floresta
          gutenberg
          inaugural
          indian
          large-grammars
          nombank-1-0
          omw-1-4
          pl196x
          porter-test
          ptb
          punkt-tab
          rte
          sinica-treebank
          stopwords
          tagsets-json
          treebank
          twitter-samples
          udhr
          universal-tagset
          wmt15-eval
          wordnet
          wordnet-ic
          words
        ]
      )
    }
  '';

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    numpy
    pyparsing
    pytest-mock

    pkgs.which
  ];

  disabledTestPaths = [
    "nltk/test/unit/test_downloader.py" # Touches network
  ];

  pythonImportsCheck = [ "nltk" ];

  passthru = {
    data = pkgs.nltk-data;
    dataDir = pkgs.callPackage ./data-dir.nix { };
  };

  meta = with lib; {
    description = "Natural Language Processing ToolKit";
    mainProgram = "nltk";
    homepage = "http://nltk.org/";
    license = licenses.asl20;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
