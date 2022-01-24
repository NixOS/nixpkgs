{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, coveralls
, pytest-cov
, cython
, numpy
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.5.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "375d37d9ab8bf501c048e44efce2276296e3d67bb276e891e0e93b0a8bbb988a";
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
