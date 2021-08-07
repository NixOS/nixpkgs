{ lib
, buildPythonPackage
, callPackage
, pythonOlder
, fetchFromGitHub
, Babel
, gruut-ipa
, jsonlines
, num2words
, python-crfsuite
, dataclasses
, python
}:

let
  langPkgs = [
    "cs"
    "de"
    "es"
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
  version = "1.2.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-qY4xsoVk1hyY9dYmVXaqDRjcShUQmp8VZOzAQNiC6EM=";
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
