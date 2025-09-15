{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

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
  version = "7.8.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    tag = version;
    hash = "sha256-w7uw5PY3uiJmxsgSB1YDbtG7IY1pd4WU3JExZRc40gs=";
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

  meta = with lib; {
    description = "User friendly Rasterio plugin to read raster datasets";
    homepage = "https://cogeotiff.github.io/rio-tiler/";
    license = licenses.bsd3;
    teams = [ lib.teams.geospatial ];
    # Tests broken with gdal 3.10
    # https://github.com/cogeotiff/rio-tiler/issues/769
    broken = true;
  };
}
