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

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:
buildPythonPackage rec {
  pname = "cltk";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cltk";
    repo = "cltk";
    tag = "v${version}";
    hash = "sha256-aeWbfDVNn6DwW+KFh62n5RBgWp5uSWDv2RHmB27/xI4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "poetry>=1.1.13" poetry-core \
      --replace-fail "poetry.masonry.api" "poetry.core.masonry.api" \
      --replace-fail 'scipy = "<1.13.0"' 'scipy = "^1"' \
      --replace-fail 'boltons = "^21.0.0"' 'boltons = "^24.0.0"'
  '';

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
