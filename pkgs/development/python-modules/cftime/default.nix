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
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77fd86e69b234d41fa8634d627e9e9ee0501c2a8a95268c2b524d38e0a33f090";
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
