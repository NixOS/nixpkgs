{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  lazy-loader,
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
  version = "1.1.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-base";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/v1LPgM2rDw9Z0en0MYGELGiRlmwQX4ILKsBEqOhhSs=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    lazy-loader
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
