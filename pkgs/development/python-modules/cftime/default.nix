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
  version = "1.6.4.post1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UKx2zJ8Qq3vUbkSnHFGmknBRtJm0QH308pqxPXQblC8=";
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
