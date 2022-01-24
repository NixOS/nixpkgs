{ lib, python, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "PyStemmer";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9b81c35302f1d2a5ad9465b85986db246990db93d97d3e8f129269ed7102788e";
  };

  nativeBuildInputs = [ cython ];

  preBuild = ''
    cython src/Stemmer.pyx
  '';

  checkPhase = ''
    ${python.interpreter} runtests.py
  '';

  meta = with lib; {
    description = "Snowball stemming algorithms, for information retrieval";
    homepage = "http://snowball.tartarus.org/";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
