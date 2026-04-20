{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  numpy,
  typing-extensions,
  xarray,

  # optional-dependencies
  h5netcdf,
  netcdf4,
  zarr,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "arviz-base";
  version = "0.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-base";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g2DmhYqO9dgvDZwAXXSDFn5wHU0BvxXNgOzk6mmEmsw=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    numpy
    typing-extensions
    xarray
  ];

  optional-dependencies = {
    h5netcdf = [
      h5netcdf
    ];
    netcdf4 = [
      netcdf4
    ];
    zarr = [
      zarr
    ];
  };

  pythonImportsCheck = [ "arviz_base" ];

  nativeCheckInputs = [
    h5netcdf
    netcdf4
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  meta = {
    description = "Base ArviZ features and converters";
    homepage = "https://github.com/arviz-devs/arviz-base";
    changelog = "https://github.com/arviz-devs/arviz-base/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
