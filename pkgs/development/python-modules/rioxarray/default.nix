{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  numpy,
  packaging,
  pyproj,
  rasterio,
  xarray,

  # tests
  dask,
  netcdf4,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "rioxarray";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corteva";
    repo = "rioxarray";
    tag = finalAttrs.version;
    hash = "sha256-+0TJeEjAKIqi6cbLZiv14dPKW8Xza+4tn/Erzn88ZS0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    packaging
    pyproj
    rasterio
    xarray
  ];

  nativeCheckInputs = [
    dask
    netcdf4
    pytestCheckHook
  ];

  disabledTests = [
    # AssertionError: Arrays are not almost equal to 7 decimals
    # Error with variable __xarray_dataarray_variable__
    "test_clip_box__auto_expand"
    "test_reproject"
    "test_reproject__grid_mapping"
    "test_reproject__str_resample"
    "test_reproject_match__pass_nodata"

    # AssertionError: assert 535727386 == 535691205
    "test_clip_geojson__no_drop"
    # Fails with GDAL 3.11 warning
    "test_rasterio_vrt"
    # Fails with small numerical errors on GDAL 3.11
    "test_rasterio_vrt_gcps"
    "test_reproject__gcps"
    # IndexError: range object index out of range (Python 3.13+)
    "test_indexing"
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch64 [
    # numerical errors
    "test_clip_geojson"
    "test_open_rasterio_mask_chunk_clip"
  ];

  pythonImportsCheck = [ "rioxarray" ];

  meta = {
    description = "Geospatial xarray extension powered by rasterio";
    homepage = "https://corteva.github.io/rioxarray/";
    changelog = "https://github.com/corteva/rioxarray/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
})
