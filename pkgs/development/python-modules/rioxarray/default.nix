{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

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
  version = "0.18.2";
  pyproject = true;
  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "corteva";
    repo = "rioxarray";
    tag = version;
    hash = "sha256-HNtMLY83e6MQakIlmsJohmhjDWiM5/hqq25qSY1dPBw=";
  };

  patches = [
    # https://github.com/corteva/rioxarray/issues/836
    (fetchpatch {
      url = "https://github.com/corteva/rioxarray/commit/6294b7468587b8c243ee4f561a90ca8de90ea0f1.patch";
      hash = "sha256-0IvDAr17ymMN1J2vC1U3z/2N1Np1RaRjCAODZthQz8g=";
    })
  ];

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
    changelog = "https://github.com/corteva/rioxarray/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
