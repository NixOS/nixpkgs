{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  async-geotiff,
  attrs,
  boto3,
  cachetools,
  color-operations,
  h5netcdf,
  hatchling,
  httpx2,
  isochron,
  morecantile,
  numexpr,
  numpy,
  obstore,
  pydantic,
  pystac,
  pytest-asyncio,
  rasterio,
  rioxarray,
  typing-extensions,
  xarray,
  zarr,
}:

buildPythonPackage (finalAttrs: {
  pname = "rio-tiler";
  version = "9.4.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    tag = finalAttrs.version;
    hash = "sha256-mrTFhZ/1I50Coh3ziOXolwhTm0mEd/7CSdheOxvPqbs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    cachetools
    color-operations
    httpx2
    morecantile
    numexpr
    numpy
    pydantic
    pystac
    rasterio
    typing-extensions
  ];

  optional-dependencies = {
    s3 = [ boto3 ];
    xarray = [ xarray rioxarray ];
    zarr = [
      isochron
      obstore
      zarr
    ];
    geoarray = [
      isochron
      rioxarray
      xarray
    ];
    geotiff = [
      async-geotiff
      obstore
    ];
  };

  nativeCheckInputs = [
    h5netcdf
    pytestCheckHook
    pytest-asyncio
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "rio_tiler" ];

  disabledTests = [
    # Requires network access
    "test_dataset_reader"

    "test_async_reader_tile"
    "test_async_mosaic_tiler"
    "test_inherit_rasterio_env_empty"
    "test_inherit_rasterio_env_not_empty"
    "test_warp_masked_pixels_propagate"

    # test is failing on aarch64
    "test_geoxarray_reader"
  ];

  meta = {
    description = "User friendly Rasterio plugin to read raster datasets";
    homepage = "https://cogeotiff.github.io/rio-tiler/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
