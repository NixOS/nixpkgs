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
  version = "6.6.1";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "cogeotiff";
    repo = "rio-tiler";
    rev = version;
    hash = "sha256-MR6kyoGM3uXt6JiIEfGcsmTmxqlLxUF9Wn+CFuK5LtQ=";
  };

  patches = [
    # fix xarray tests, remove on next release
    (fetchpatch {
      url = "https://github.com/cogeotiff/rio-tiler/commit/7a36ed58b649d2f4d644f280b54851ecb7ffa4e9.patch";
      hash = "sha256-QlX5ZKpjSpXevi76gx39dXok0aClApkLU0cAVpCuYYs=";
    })
  ];

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
