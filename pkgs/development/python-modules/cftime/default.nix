{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, coveralls
, pytestcov
, cython
, numpy
, python
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7c55540bc164746c3c4f86a07c9c7b9ed4dfb0b0d988348ec63cec065c58766d";
  };

  checkInputs = [
    pytestCheckHook
    coveralls
    pytestcov
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
