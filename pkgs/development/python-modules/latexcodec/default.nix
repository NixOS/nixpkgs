{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "1.0.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wnp3yqcgx0rpy8dz51vh75lbp2qif67da19zi7m3ca98n887hgb";
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = "https://github.com/mcmtroffaes/latexcodec";
    description = "Lexer and codec to work with LaTeX code in Python";
    license = stdenv.lib.licenses.mit;
  };

}
