{ lib
, buildPythonPackage
, callPackage
, pythonOlder
, fetchFromGitHub
, Babel
, gruut-ipa
, dateparser
, jsonlines
, num2words
, python-crfsuite
, dataclasses
, python
, networkx
, glibcLocales
, pytestCheckHook
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
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-9vj3x2IjTso8ksN1cqe5frwg0Y3GhOB6bPWvaBSBOf8=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "dateparser~=1.0.0" "dateparser" \
      --replace "gruut_lang_en~=2.0.0" "gruut_lang_en" \
      --replace "jsonlines~=1.2.0" "jsonlines"
  '';

  propagatedBuildInputs = [
    Babel
    gruut-ipa
    jsonlines
    num2words
    python-crfsuite
    dateparser
    networkx
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ (map (lang: callPackage ./language-pack.nix {
    inherit lang version format src;
  }) langPkgs);

  checkInputs = [ glibcLocales pytestCheckHook ];

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

  pythonImportsCheck = [
    "gruut"
  ];

  meta = with lib; {
    description = "A tokenizer, text cleaner, and phonemizer for many human languages";
    homepage = "https://github.com/rhasspy/gruut";
    license = licenses.mit;
    maintainers = teams.tts.members;
  };
}
