{ lib
, buildPythonPackage
, fetchPypi
, numpy
, razdel
, gensim
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "navec";
  version = "0.10.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TyNHSxwnmvbGBfhOeHPofEfKWLDFOKP50w2QxgnJ/SE=";
  };

  propagatedBuildInputs = [ numpy razdel ];
  nativeCheckInputs = [ pytestCheckHook gensim ];
  # TODO: remove when gensim usage will be fixed in `navec`.
  disabledTests = [ "test_gensim" ];
  pythonImportCheck = [ "navec" ];

  meta = with lib; {
    description = "Compact high quality word embeddings for Russian language";
    homepage = "https://github.com/natasha/navec";
    license = licenses.mit;
    maintainers = with maintainers; [ npatsakula ];
  };
}
