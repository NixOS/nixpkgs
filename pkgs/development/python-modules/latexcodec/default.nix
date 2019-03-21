{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "1.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0s4wdbg0w2l8pj3i0y4510i0s04p8nhxcsa2z41bjsv0k66npb81";
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = stdenv.lib.licenses.mit;
  };

}
