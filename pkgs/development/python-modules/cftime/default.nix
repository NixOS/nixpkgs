{
  lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  numpy,
  setuptools,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cftime";
  version = "1.6.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-giX+1rm0P7h2g+urUhMEUPwXMAERUNMJIJapDlTR6B4=";
  };

  build-system = [
    setuptools
    cython
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "cftime" ];

  meta = {
    description = "Time-handling functionality from netcdf4-python";
    changelog = "https://github.com/Unidata/cftime/blob/v${finalAttrs.version}rel/Changelog";
    homepage = "https://github.com/Unidata/cftime";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
