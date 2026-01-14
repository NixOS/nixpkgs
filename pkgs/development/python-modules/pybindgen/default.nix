{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pygccxml,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pybindgen";
  version = "0.22.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "PyBindGen";
    inherit version;
    hash = "sha256-jH8iORpJqEUY9aKtBuOlseg50Q402nYxUZyKKPy6N2Q=";
  };

  buildInputs = [ setuptools-scm ];

  nativeCheckInputs = [ pygccxml ];

  pythonImportsCheck = [ "pybindgen" ];

  # Fails to import module 'cxxfilt' from pygccxml on Py3k
  doCheck = (!isPy3k);

  meta = {
    description = "Python Bindings Generator";
    homepage = "https://github.com/gjcarneiro/pybindgen";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ teto ];
  };
}
