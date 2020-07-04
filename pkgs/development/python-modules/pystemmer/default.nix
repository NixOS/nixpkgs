{ stdenv, python, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "PyStemmer";
  version = "2.0.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "57d1e353b11c5f90566efec7037deaa0e411b1df1e4e5522ce97d7be34b49478";
  };

  nativeBuildInputs = [ cython ];

  preBuild = ''
    cython src/Stemmer.pyx
  '';

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with stdenv.lib; {
    description = "Snowball stemming algorithms, for information retrieval";
    homepage = "http://snowball.tartarus.org/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
