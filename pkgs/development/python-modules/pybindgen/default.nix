{ lib, fetchPypi, buildPythonPackage, isPy3k, setuptools-scm, pygccxml }:
buildPythonPackage rec {
  pname = "PyBindGen";
  version = "0.22.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jH8iORpJqEUY9aKtBuOlseg50Q402nYxUZyKKPy6N2Q=";
  };

  buildInputs = [ setuptools-scm ];

  checkInputs = [ pygccxml ];
  doCheck = (!isPy3k); # Fails to import module 'cxxfilt' from pygccxml on Py3k

  meta = with lib; {
    homepage = "https://github.com/gjcarneiro/pybindgen";
    description = "Python Bindings Generator";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ teto ];
  };
}
