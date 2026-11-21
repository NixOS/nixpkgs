{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  comet-maths,
  netcdf4,
  xarray,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "obsarray";
  version = "1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "comet-toolkit";
    repo = "obsarray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6cSd7avX6rJRgaUNvoAey73U7z4blNhkEN6gnQz1+WI=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    comet-maths
    netcdf4
    xarray
  ];
  pythonImportsCheck = [
    "obsarray"
  ];
  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Measurement data handling in Python";
    homepage = "https://obsarray.readthedocs.io/en/latest/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
})
