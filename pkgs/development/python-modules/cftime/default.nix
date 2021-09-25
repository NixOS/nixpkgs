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
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a398caed78389b366f1037ca62939ff01af2f1789c77bce05eb903f19ffd840";
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
