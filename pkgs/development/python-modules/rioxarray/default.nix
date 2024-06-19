{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  dask,
  netcdf4,
  numpy,
  packaging,
  pyproj,
  rasterio,
  setuptools,
  xarray,
}:

buildPythonPackage rec {
  pname = "rioxarray";
  version = "0.15.5";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "corteva";
    repo = "rioxarray";
    rev = version;
    hash = "sha256-bumFZQktgUqo2lyoLtDXkh6Vv5oS/wobqYpvNYy7La0=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
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

  disabledTests = [ "test_clip_geojson__no_drop" ];

  pythonImportsCheck = [ "rioxarray" ];

  meta = {
    description = "geospatial xarray extension powered by rasterio";
    homepage = "https://corteva.github.io/rioxarray/";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
