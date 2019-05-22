{ stdenv, fetchPypi, buildPythonPackage, isPy3k, setuptools_scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.19.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23f2b760e352729208cd4fbadbc618bd00f95a0a24db21a4182833afcc3b5208";
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
