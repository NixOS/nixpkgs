{ stdenv
, buildPythonPackage
, fetchPypi
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "funcparserlib";
  version = "0.3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7992eac1a3eb97b3d91faa342bfda0729e990bd8a43774c1592c091e563c91d";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  # Tests are Python 2.x only judging from SyntaxError
  doCheck = !(isPy3k);

  meta = with stdenv.lib; {
    description = "Recursive descent parsing library based on functional combinators";
    homepage = "https://github.com/vlasovskikh/funcparserlib";
    license = licenses.mit;
    platforms = platforms.unix;
  };

}
