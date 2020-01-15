{ stdenv, fetchPypi, buildPythonPackage, isPy3k, setuptools_scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.20.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l9pz4s7p82ddf9nq56y1fk84j5dbsff1r2xnfily0m7sahyvc8g";
  };

  buildInputs = [ setuptools_scm ];

  checkInputs = [ pygccxml ];
  doCheck = (!isPy3k); # Fails to import module 'cxxfilt' from pygccxml on Py3k

  meta = with stdenv.lib; {
    homepage = https://github.com/gjcarneiro/pybindgen;
    description = "Python Bindings Generator";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ teto ];
  };
}
