{
  lib,
  pkgs,
  fetchPypi,
  fetchpatch,
  buildPythonPackage,
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

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D0CemwacpBd8GQPD6EPu+Qx+kpkvpJMa5gfabeSeFBk=";
  };

  patches = [
    # https://github.com/nltk/nltk/security/advisories/GHSA-jm6w-m3j8-898g
    # https://github.com/NixOS/nixpkgs/issues/502599
    (fetchpatch {
      name = "fix-unauthed-shutdown";
      url = "https://github.com/nltk/nltk/commit/bbaae83db86a0f49e00f5b0db44a7254c268de9b.patch";
      hash = "sha256-1ZzOQXiNxZ6o7JQs0b9FpsUjZtuUAjXEmDkc9mV3dYU=";
    })

    # https://github.com/nltk/nltk/security/advisories/GHSA-469j-vmhf-r6v7
    # https://github.com/NixOS/nixpkgs/issues/502535
    (fetchpatch {
      name = "fix-downloader-path-traversal";
      url = "https://github.com/nltk/nltk/commit/89fe2ec2c6bae6e2e7a46dad65cc34231976ed8a.patch";
      hash = "sha256-hQJmVEDDcio4Ew+Y10WzMV53mpYZuuDsFcEZKEzl7nk=";
    })
  ];

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

  meta = {
    description = "Natural Language Processing ToolKit";
    mainProgram = "nltk";
    homepage = "http://nltk.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bengsparks ];
  };
}
