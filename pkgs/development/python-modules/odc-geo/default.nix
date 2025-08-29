{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

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
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "odc-geo";
  version = "0.4.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opendatacube";
    repo = "odc-geo";
    tag = "v${version}";
    hash = "sha256-f4wUUzcv4NM44zrCvW3sBRybppIBZEAm+oiTSW1B+Fw=";
  };

  build-system = [
    setuptools
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
    matplotlib
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # AttributeError (fixes: https://github.com/opendatacube/odc-geo/pull/202)
    "test_azure_multipart_upload"
    # network access
    "test_empty_cog"
    # urllib url open error
    "test_country_geom"
    "test_from_geopandas"
    "test_geoboxtiles_intersect"
    "test_warp_nan"
    # requires imagecodecs package (currently not available on nixpkgs)
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
    changelog = "https://github.com/opendatacube/odc-geo/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
