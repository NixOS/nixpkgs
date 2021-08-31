{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, coveralls
, pytest-cov
, cython
, numpy
, python
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b644bcb53346b6f4fe2fcc9f3b574740a2097637492dcca29632c817e0604f29";
  };

  checkInputs = [
    pytestCheckHook
    coveralls
    pytest-cov
  ];

  nativeBuildInputs = [
    cython
    numpy
  ];

  propagatedBuildInputs = [
    numpy
  ];

  # ERROR test/test_cftime.py - ModuleNotFoundError: No module named 'cftime._cft...
  doCheck = false;

  meta = {
    description = "Time-handling functionality from netcdf4-python";
  };

}
