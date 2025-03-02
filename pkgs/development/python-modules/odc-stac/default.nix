{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  affine,
  dask,
  numpy,
  odc-geo,
  pandas,
  pystac,
  rasterio,
  toolz,
  xarray,

  # optional-dependencies
  botocore,

  # tests
  geopandas,
  distributed,
  pystac-client,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "odc-stac";
  version = "0.3.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opendatacube";
    repo = "odc-stac";
    tag = "v${version}";
    hash = "sha256-uudBzxVGt3RW4ppDrFYfA9LMa2xPfs3FTBzVS19FjB4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    affine
    dask
    numpy
    odc-geo
    pandas
    pystac
    rasterio
    toolz
    xarray
  ];

  optional-dependencies = {
    botocore = [ botocore ];
  };

  nativeCheckInputs = [
    geopandas
    distributed
    pystac-client
    pytestCheckHook
  ] ++ optional-dependencies.botocore;

  pytestFlagsArray = [ "-m 'not network'" ];

  disabledTests = [
    # pystac href error (possible related to network)
    "test_extract_md"
    "test_parse_item"
    "test_parse_item_no_proj"
    # urllib url open error
    "test_norm_geom"
    "test_output_geobox"
    "test_mem_reader"
    "test_memreader_zarr"

  ];

  pythonImportsCheck = [
    "odc.stac"
  ];

  meta = {
    description = "Load STAC items into xarray Datasets.";
    homepage = "https://github.com/opendatacube/odc-stac/";
    changelog = "https://github.com/opendatacube/odc-stac/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
