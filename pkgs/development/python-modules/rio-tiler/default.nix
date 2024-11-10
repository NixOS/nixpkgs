{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
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
  version = "6.7.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    rev = "refs/tags/${version}";
    hash = "sha256-i70Bh7RHPgLLaqBo9vHRrJylsNE3Ly3xJq9j12Ch58E=";
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
    maintainers = lib.teams.geospatial.members;
  };
}
