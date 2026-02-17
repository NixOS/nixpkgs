{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  attrs,
  boto3,
  cachetools,
  color-operations,
  hatchling,
  httpx,
  morecantile,
  numexpr,
  numpy,
  pydantic,
  pystac,
  rasterio,
  rioxarray,
}:

buildPythonPackage rec {
  pname = "rio-tiler";
  version = "8.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    tag = version;
    hash = "sha256-FOTwP4iTLfWl81KKarLOQQyp4gpi6Q+pjUXfZrXXsfo=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
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

  nativeCheckInputs = [
    boto3
    pytestCheckHook
    rioxarray
  ];

  pythonImportsCheck = [ "rio_tiler" ];

  meta = {
    description = "User friendly Rasterio plugin to read raster datasets";
    homepage = "https://cogeotiff.github.io/rio-tiler/";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.geospatial ];
    # Tests broken with gdal 3.10
    # https://github.com/cogeotiff/rio-tiler/issues/769
    broken = true;
  };
}
