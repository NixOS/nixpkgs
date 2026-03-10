{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

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
  rasterio,
  rioxarray,
  zarr,
}:

buildPythonPackage (finalAttrs: {
  pname = "rio-tiler";
  version = "8.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    tag = finalAttrs.version;
    hash = "sha256-FOTwP4iTLfWl81KKarLOQQyp4gpi6Q+pjUXfZrXXsfo=";
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

  pythonImportsCheck = [ "rio_tiler" ];

  disabledTests = [
    # Requires network access
    "test_dataset_reader"
  ];

  meta = {
    description = "User friendly Rasterio plugin to read raster datasets";
    homepage = "https://cogeotiff.github.io/rio-tiler/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
  };
})
