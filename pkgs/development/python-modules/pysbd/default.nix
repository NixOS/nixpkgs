{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, tqdm
, spacy
}:

buildPythonPackage rec {
  pname = "pysbd";
  version = "0.3.3";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "56ab48a28a8470f0042a4cb7c9da8a6dde8621ecf87a86d75f201cbf1837e77f";
  };

  checkInputs = [ tqdm spacy ];

  doCheck = false; # requires pyconll and blingfire

  pythonImportsCheck = [ "pysbd" ];

  meta = with lib; {
    description = "Pysbd (Python Sentence Boundary Disambiguation) is a rule-based sentence boundary detection that works out-of-the-box across many languages";
    homepage = "https://github.com/nipunsadvilkar/pySBD";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
