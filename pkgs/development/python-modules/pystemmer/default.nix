{ lib, python, fetchPypi, buildPythonPackage, cython }:

buildPythonPackage rec {
  pname = "PyStemmer";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-4hcbkbhrscap3d8J6Mhn5Ij4vWm94H0EEKNc3O4NhXw=";
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
