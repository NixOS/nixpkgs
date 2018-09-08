{ stdenv, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "latexcodec";
  version = "1.0.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zdd1gf24i83ykadx0y30n3001j43scqr2saql3vckk5c39dj1wn";
  };

  propagatedBuildInputs = [ six ];

  meta = {
    homepage = https://github.com/mcmtroffaes/latexcodec;
    description = "Lexer and codec to work with LaTeX code in Python";
    license = stdenv.lib.licenses.mit;
  };

}
