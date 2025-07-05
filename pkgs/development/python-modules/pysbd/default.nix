{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  tqdm,
  spacy,
}:

buildPythonPackage rec {
  pname = "pysbd";
  version = "0.3.4";
  format = "setuptools";
  disabled = pythonOlder "3.5";

  # provides no sdist on pypi
  src = fetchFromGitHub {
    owner = "nipunsadvilkar";
    repo = "pySBD";
    rev = "v${version}";
    sha256 = "12p7qm237z56hw4zr03n8rycgfymhki2m9c4w3ib0mvqq122a5dp";
  };

  nativeCheckInputs = [
    tqdm
    spacy
  ];

  doCheck = false; # requires pyconll and blingfire

  pythonImportsCheck = [ "pysbd" ];

  meta = with lib; {
    description = "Pysbd (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box across many languages";
    homepage = "https://github.com/nipunsadvilkar/pySBD";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
