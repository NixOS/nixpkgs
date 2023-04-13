{ lib
, buildPythonPackage
, fetchPypi
, pytest
, hypothesis
, hypothesmith
, python
}:

buildPythonPackage rec {
  pname = "mccabe";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NI4CQMM7YLvfTlIxku+RnyjLLD19XHeU90AJKQ8jYyU=";
  };

  buildInputs = [
    pytest
  ];

  # https://github.com/PyCQA/mccabe/issues/93
  doCheck = false;

  meta = with lib; {
    description = "McCabe checker, plugin for flake8";
    homepage = "https://github.com/flintwork/mccabe";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
