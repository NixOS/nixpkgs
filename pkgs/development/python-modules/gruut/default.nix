{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  babel,
  gruut-ipa,
  dateparser,
  jsonlines,
  num2words,
  python-crfsuite,
  networkx,

  # checks
  glibcLocales,
  pytestCheckHook,
}:

let
  langPkgs = [
    "ar"
    "cs"
    "de"
    "en"
    "es"
    "fa"
    "fr"
    "it"
    "lb"
    "nl"
    "pt"
    "ru"
    "sv"
    "sw"
  ];
in
buildPythonPackage rec {
  pname = "gruut";
  version = "2.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "gruut";
    rev = "refs/tags/v${version}";
    hash = "sha256-DD7gnvH9T2R6E19+exWE7Si+XEpfh0Iy5FYbycjgzgM=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies =
    [
      babel
      gruut-ipa
      jsonlines
      num2words
      python-crfsuite
      dateparser
      networkx
    ]
    ++ (map (
      lang:
      callPackage ./language-pack.nix {
        inherit
          lang
          version
          src
          build-system
          ;
      }
    ) langPkgs);

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/rhasspy/gruut/issues/25
    "test_lexicon_external"

    # requires mishkal library
    "test_fa"
    "test_ar"
    "test_lb"
  ];

  preCheck = ''
    export LC_ALL=en_US.utf-8
  '';

  pythonImportsCheck = [ "gruut" ];

  meta = with lib; {
    description = "Tokenizer, text cleaner, and phonemizer for many human languages";
    mainProgram = "gruut";
    homepage = "https://github.com/rhasspy/gruut";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
