{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "mccabe";
  version = "0.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NI4CQMM7YLvfTlIxku+RnyjLLD19XHeU90AJKQ8jYyU=";
  };

  buildInputs = [ pytest ];

  # https://github.com/PyCQA/mccabe/issues/93
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "McCabe checker, plugin for flake8";
    homepage = "https://github.com/flintwork/mccabe";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "McCabe checker, plugin for flake8";
    homepage = "https://github.com/flintwork/mccabe";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
