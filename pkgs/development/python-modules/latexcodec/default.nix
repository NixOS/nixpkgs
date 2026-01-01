{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  pytest,
}:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-54ppEc1y+d7DUDHG7CNYTeaEK/vEYQqWeIaNFM37A1c=";
  };

  propagatedBuildInputs = [ six ];

  nativeCheckInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
