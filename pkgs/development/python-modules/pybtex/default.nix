{
  lib,
  buildPythonPackage,
  fetchPypi,
  latexcodec,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  version = "0.24.0";
  format = "setuptools";
  pname = "pybtex";

  doCheck = false;
  pythonImportsCheck = [ "pybtex" ];

  propagatedBuildInputs = [
    latexcodec
    pyyaml
    setuptools
  ];

  src = fetchPypi {
    inherit version pname;
    hash = "sha256-gY6uNbYXM+XAB8P80s+3XtG8i0FzwfcLVsxMCALTR1U=";
  };

  meta = with lib; {
    homepage = "https://pybtex.org/";
    description = "BibTeX-compatible bibliography processor written in Python";
    license = licenses.mit;
  };
}
