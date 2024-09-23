{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  numpy,
  packaging,
  pyproj,
  rasterio,
  xarray,
  # tests
  dask,
  netcdf4,
  pytestCheckHook,
  stdenv,
}:

buildPythonPackage rec {
  pname = "rioxarray";
  version = "0.17.0";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "corteva";
    repo = "rioxarray";
    rev = "refs/tags/${version}";
    hash = "sha256-mOXyfkreQ55vWmPCG2U/ijcKZqzHoQQLfKArSh2fDmA=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  disabledTests =
    [ "test_clip_geojson__no_drop" ]
    ++ lib.optionals
      (stdenv.hostPlatform.system == "aarch64-linux" || stdenv.hostPlatform.system == "aarch64-darwin")
      [
        # numerical errors
        "test_clip_geojson"
        "test_open_rasterio_mask_chunk_clip"
      ];

  pythonImportsCheck = [ "rioxarray" ];

  meta = {
    description = "geospatial xarray extension powered by rasterio";
    homepage = "https://corteva.github.io/rioxarray/";
    changelog = "https://github.com/corteva/rioxarray/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
