{
  lib,
  stdenv,
  pkgs,
  fetchFromGitHub,
  buildPythonPackage,
  click,
  defusedxml,
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
  version = "3.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nltk";
    repo = "nltk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PaMW9QNV+++Gz+OoG7m2VFn6L3vkG/Mg9ZLx9KlN19U=";
  };

  postPatch = ''
    # NLTK's immutable-root model does not include the Nix store. Trust it for
    # data roots and read-only symlinks produced by nltk-data-dir.
    substituteInPlace nltk/pathsec.py \
      --replace-fail 'if not (target == scoped_root or target.is_relative_to(scoped_root)):' \
                     'if not (target == scoped_root or target.is_relative_to(scoped_root) or target.is_relative_to("/nix/store")):' \
      --replace-fail 'candidate_locs = ["~/nltk_data", "/usr/share/nltk_data"]' \
                     'candidate_locs = ["~/nltk_data", "/usr/share/nltk_data", "/nix/store"]' \
      --replace-fail 'if ENFORCE and os.name == "posix":' \
                     'if ENFORCE and os.name == "posix" and not (_is_readonly_mode(mode) and Path(os.path.abspath(raw_path)).is_relative_to("/nix/store")):'
  '';

  build-system = [ setuptools ];

  dependencies = [
    click
    defusedxml
    joblib
    regex
    tqdm
  ];

  preInstallCheck = ''
    export NLTK_DATA=${
      nltk.dataDir (
        d: with d; [
          averaged-perceptron-tagger-eng
          averaged-perceptron-tagger-rus
          bcp47
          brown
          cess-cat
          cess-esp
          conll2007
          floresta
          gutenberg
          ieer
          inaugural
          indian
          large-grammars
          nombank-1-0
          omw-2-0
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

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/nltk/nltk/blob/${finalAttrs.src.tag}/ChangeLog";
    description = "Natural Language Processing ToolKit";
    mainProgram = "nltk";
    homepage = "https://nltk.org/";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bengsparks ];
  };
})
