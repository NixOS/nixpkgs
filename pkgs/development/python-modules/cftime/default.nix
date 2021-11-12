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
  version = "1.5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6dc4d76ec7fe5a2d3c00dbe6604c757f1319613b75ef157554ef3648bf102a50";
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
