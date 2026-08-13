{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  boltons,
  gensim,
  gitpython,
  greek-accentuation,
  nltk,
  pyyaml,
  rapidfuzz,
  requests,
  scikit-learn,
  scipy,
  spacy,
  stanza,
  torch,
  tqdm,
  colorama,
  python-dotenv,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "cltk";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cltk";
    repo = "cltk";
    tag = "v${version}";
    hash = "sha256-tAomXxI6XsIAxQzPiUsT5t1CHrFDPkwyWtVuHXQCz2A=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "spacy"
  ];

  dependencies = [
    boltons
    gensim
    gitpython
    greek-accentuation
    nltk
    pyyaml
    rapidfuzz
    requests
    scikit-learn
    scipy
    spacy
    stanza
    torch
    tqdm
    colorama
    python-dotenv
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Most of tests fail as they require local files to be present and also internet access
  doCheck = false;

  meta = {
    description = "Natural language processing (NLP) framework for pre-modern languages";
    homepage = "https://cltk.org";
    changelog = "https://github.com/cltk/cltk/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kmein ];
  };
}
