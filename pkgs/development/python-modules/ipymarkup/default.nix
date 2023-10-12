{ lib
, buildPythonPackage
, fetchPypi
, intervaltree
}:

buildPythonPackage rec {
  pname = "ipymarkup";
  version = "0.9.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P0v6EP1mKTIBr4SEp+a8tyO/LjPZpqoAiCZxr5yiaRE=";
  };

  propagatedBuildInputs = [ intervaltree ];
  pythonImportCheck = [ "ipymarkup" ];

  # Upstream has no tests:
  doCheck = false;

  meta = with lib; {
    description = "Collection of NLP visualizations for NER and syntax tree markup";
    homepage = "https://github.com/natasha/ipymarkup";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
