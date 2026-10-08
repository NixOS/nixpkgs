{
  lib,
  buildPythonPackage,
  arviz,
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
  inherit (arviz) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "arviz-devs";
    repo = "arviz-base";
    tag = "v${finalAttrs.version}";
    hash = "sha256-viGjQrAeelzC7DBqMA4kltBllDAXJvymWdntOMYapEA=";
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

  pytestFlags = [
    # DeprecationWarning: Setting the shape on a NumPy array has been deprecated in NumPy 2.5.
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Base ArviZ features and converters";
    homepage = "https://github.com/arviz-devs/arviz-base";
    changelog = "https://github.com/arviz-devs/arviz-base/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
