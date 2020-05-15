{ stdenv, buildPythonPackage, fetchPypi, six, pytest }:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0pyzhidpnc3q3rh9d5hxhzv99rl5limyyrll7xcyssci92fn8gyd";
  };

  propagatedBuildInputs = [ six ];

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest
  '';

  meta = {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = stdenv.lib.licenses.mit;
  };

}
