{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pytest,
}:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "3.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kX3F/iQnYswZ2WPmVItC1joRgCjN0zYdYjl+O2OLa8U=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = licenses.mit;
  };
}
