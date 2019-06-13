{ stdenv, python, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "PyStemmer";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d1ac14eb64978c1697fcfba76e3ac7ebe24357c9428e775390f634648947cb91";
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
    homepage = http://snowball.tartarus.org/;
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
