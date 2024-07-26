{ lib, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "16pynfnn8y8xp55yp06i721fccv5dlx9ba6k5bzcwq9j6wf5b8ia";
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
