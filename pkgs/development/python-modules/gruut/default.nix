{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  babel,
  dateparser,
  gruut-ipa,
  jsonlines,
  networkx,
  num2words,
  numpy,
  python-crfsuite,

  # optional dependencies
  pydub,
  rapidfuzz,

  # checks
  glibcLocales,
  pytestCheckHook,
}:

let
  langPkgs = [
    "ar"
    "ca"
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
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "gruut";
    rev = "refs/tags/v${version}";
    hash = "sha256-iwde6elsAbICZ+Rc7CPgcZTOux1hweVZc/gf4K+hP9M=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    babel
    dateparser
    gruut-ipa
    jsonlines
    networkx
    num2words
    numpy
    python-crfsuite
  ] ++ optional-dependencies.en;

  optional-dependencies =
    {
      train = [
        pydub
        rapidfuzz
      ];
    }
    // lib.genAttrs langPkgs (lang: [
      (callPackage ./language-pack.nix {
        inherit
          lang
          version
          src
          build-system
          ;
      })
    ]);

  nativeCheckInputs = [
    glibcLocales
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTests = [
    # https://github.com/rhasspy/gruut/issues/25
    "test_lexicon_external"

    # requires mishkal library
    "test_fa"
    "test_ar"
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
