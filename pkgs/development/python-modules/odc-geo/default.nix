{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  affine,
  cachetools,
  numpy,
  pyproj,
  shapely,

  # optional-dependencies
  azure-storage-blob,
  boto3,
  dask,
  distributed,
  rasterio,
  tifffile,
  xarray,

  # tests
  geopandas,
  imagecodecs,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "odc-geo";
  version = "0.5.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "opendatacube";
    repo = "odc-geo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iubxn3ysx7aIMSrlrPPnfKYI8K7wSugM0/Zp2YIXeIg=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    affine
    cachetools
    numpy
    pyproj
    shapely
  ];

  optional-dependencies = {
    xr = [ xarray ];
    wrap = [ rasterio ];
    tiff = [
      dask
      distributed
      rasterio
      tifffile
      xarray
    ];
    s3 = [ boto3 ];
    az = [ azure-storage-blob ];
    all = [
      azure-storage-blob
      boto3
      dask
      distributed
      rasterio
      tifffile
      xarray
    ];
  };

  nativeCheckInputs = [
    geopandas
    imagecodecs
    matplotlib
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.all;

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # Require internet access
    "test_country_geom"
    "test_from_geopandas"
    "test_geoboxtiles_intersect"
    "test_warp_nan"

    # imagecodecs.ImcdError: imcd_byteshuffle returned IMCD_VALUE_ERROR
    "test_cog_with_dask_smoke_test"
  ];

  pythonImportsCheck = [
    "odc.geo"
    "odc.geo.xr"
  ];

  meta = {
    description = "GeoBox and geometry utilities extracted from datacube-core";
    longDescription = ''
      This library combines geometry shape classes from `shapely` with CRS from
      `pyproj` to provide a number of data types and utilities useful for working
      with geospatial metadata and geo-registered `xarray` rasters.
    '';
    homepage = "https://github.com/opendatacube/odc-geo/";
    changelog = "https://github.com/opendatacube/odc-geo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
})
