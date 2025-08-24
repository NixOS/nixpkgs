{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,
  versioneer,

  # dependencies
  comet-maths,
  netcdf4,
  xarray,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "obsarray";
  version = "1.0.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-75bVIwB0ojKpNFdYsGIgRczCo0qHme20XZ12fzO+akQ=";
  };

  build-system = [
    setuptools
    wheel
    versioneer
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
}
