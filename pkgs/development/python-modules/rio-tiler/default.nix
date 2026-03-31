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
  httpx,
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
  zarr,
}:

buildPythonPackage (finalAttrs: {
  pname = "rio-tiler";
  version = "9.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    tag = finalAttrs.version;
    hash = "sha256-R8vmb33ZfKGqRLkJ55npL031Gnc7HTUDeWiCvtaLsiM=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    cachetools
    color-operations
    httpx
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
    xarray = [ rioxarray ];
    zarr = [
      obstore
      zarr
    ];
  };

  nativeCheckInputs = [
    h5netcdf
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  checkInputs = [
    async-geotiff
    pytest-asyncio
  ];

  pythonImportsCheck = [ "rio_tiler" ];

  disabledTests = [
    # Requires network access
    "test_dataset_reader"
    # for some reason, str date representation are not the same
    "test_xarray_reader"
  ];

  meta = {
    description = "User friendly Rasterio plugin to read raster datasets";
    homepage = "https://cogeotiff.github.io/rio-tiler/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
