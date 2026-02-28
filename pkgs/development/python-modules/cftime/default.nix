{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cftime";
  version = "1.6.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-giX+1rm0P7h2g+urUhMEUPwXMAERUNMJIJapDlTR6B4=";
  };

  nativeBuildInputs = [
    cython
    numpy
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cftime" ];

  meta = {
    description = "Time-handling functionality from netcdf4-python";
    homepage = "https://github.com/Unidata/cftime";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
