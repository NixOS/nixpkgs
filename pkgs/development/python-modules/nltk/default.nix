{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  joblib,
  regex,
  setuptools,
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

buildPythonPackage (finalAttrs: {
  pname = "nltk";
  version = "3.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nltk";
    repo = "nltk";
    tag = finalAttrs.version;
    hash = "sha256-kDfMiqXgLq91zzDjv/qDn0XwQkYRn2sITI6E4pgWe/8=";
  };

  postPatch = ''
    # In the nix store we trust
    substituteInPlace nltk/pathsec.py \
      --replace-fail 'if not (target == scoped_root or target.is_relative_to(scoped_root)):' 'if not (target == scoped_root or target.is_relative_to(scoped_root) or target.is_relative_to("/nix/store")):'
  '';

  build-system = [ setuptools ];

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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # ModuleNotFoundError: No module named '_tkinter'
    "test_chartparser_app_uses_pickle_load_not_pickle_load_standard"
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
})
