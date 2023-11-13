{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, babel
, gruut-ipa
, dateparser
, jsonlines
, num2words
, python-crfsuite
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
  version = "2.3.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DD7gnvH9T2R6E19+exWE7Si+XEpfh0Iy5FYbycjgzgM=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "gruut_lang_en~=2.0.0" "gruut_lang_en" \
      --replace "jsonlines~=1.2.0" "jsonlines" \
      --replace "networkx>=2.5.0,<3.0.0" "networkx"
  '';

  propagatedBuildInputs = [
    babel
    gruut-ipa
    jsonlines
    num2words
    python-crfsuite
    dateparser
    networkx
  ] ++ (map (lang: callPackage ./language-pack.nix {
    inherit lang version format src;
  }) langPkgs);

  nativeCheckInputs = [ glibcLocales pytestCheckHook ];

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
