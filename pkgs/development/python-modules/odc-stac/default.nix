{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit-core,

  # dependencies
  affine,
  dask,
  numpy,
  odc-geo,
  odc-loader,
  pandas,
  pystac,
  rasterio,
  toolz,
  typing-extensions,
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
  version = "0.5.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opendatacube";
    repo = "odc-stac";
    tag = "v${version}";
    hash = "sha256-OlqUFyysbteZ+Ek48+F4U0YLrTx624974O7DnnUuxag=";
  };

  build-system = [ flit-core ];

  dependencies = [
    affine
    dask
    numpy
    odc-geo
    odc-loader
    pandas
    pystac
    rasterio
    toolz
    typing-extensions
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
  ]
  ++ optional-dependencies.botocore;

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # pystac href error (possible related to network)
    "test_extract_md"
    "test_parse_item"
    "test_parse_item_no_proj"
    # urllib url open error
    "test_norm_geom"
    "test_output_geobox"
  ];

  pythonImportsCheck = [ "odc.stac" ];

  meta = {
    description = "Load STAC items into xarray Datasets";
    homepage = "https://github.com/opendatacube/odc-stac/";
    changelog = "https://github.com/opendatacube/odc-stac/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
