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
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8d6a1144f43b9d7a180d7ceb3aa8015b7133c615fbac231bed184a91129f0207";
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
