{ lib
, buildPythonPackage
, callPackage
, pythonOlder
, fetchFromGitHub
, Babel
, gruut-ipa
, jsonlines
, num2words
, numpy
, python-crfsuite
, dataclasses
, python
}:

let
  langPkgs = [
    "ar"
    "cs"
    "de"
    "es"
    "fa"
    "fr"
    "it"
    "nl"
    "pt"
    "ru"
    "sv"
    "sw"
  ];
in
buildPythonPackage rec {
  pname = "gruut";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pJ7HwFOyEsKR/IlntOUomK2WXuD7B8kJ63dcSwvzBb4=";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "Babel~=2.8.0" "Babel"
  '';

  propagatedBuildInputs = [
    Babel
    gruut-ipa
    jsonlines
    num2words
    numpy
    python-crfsuite
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ (map (lang: callPackage ./language-pack.nix {
    inherit lang version format src;
  }) langPkgs);

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m unittest discover
    runHook postCheck
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
