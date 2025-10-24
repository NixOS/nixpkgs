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

buildPythonPackage rec {
  pname = "rioxarray";
  version = "0.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corteva";
    repo = "rioxarray";
    tag = version;
    hash = "sha256-yLWCDaAcwQT2C0Nt1GaIA3NWXe6k2CDkBAr3rsm8eQs=";
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
    # AssertionError: assert 535727386 == 535691205
    "test_clip_geojson__no_drop"
    # Fails with GDAL 3.11 warning
    "test_rasterio_vrt"
    # Fails with small numerical errors on GDAL 3.11
    "test_rasterio_vrt_gcps"
    "test_reproject__gcps"
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
    changelog = "https://github.com/corteva/rioxarray/releases/tag/${version}";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
