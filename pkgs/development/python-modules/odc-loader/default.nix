{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  flit,
  setuptools,

  # dependencies
  dask,
  numpy,
  odc-geo,
  rasterio,
  xarray,

  # optional-dependencies
  botocore,
  zarr,

  # tests
  geopandas,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "odc-loader";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "opendatacube";
    repo = "odc-loader";
    tag = "v${version}";
    hash = "sha256-yBCityE9e29wUnPuD09MTeyyVY/o9X/1lUq3Su8sd6g=";
  };

  build-system = [
    flit
  ];

  dependencies = [
    dask
    numpy
    odc-geo
    rasterio
    xarray
  ];

  optional-dependencies = {
    botocore = [ botocore ];
    zarr = [ zarr ];
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);
  };

  nativeCheckInputs = [
    geopandas
    pytestCheckHook
  ]
  ++ optional-dependencies.all;

  disabledTests = [
    # Require internet access
    "test_mem_reader"
    "test_memreader_zarr"
  ];

  pythonImportsCheck = [
    "odc.loader"
  ];

  meta = {
    description = "Tools for constructing xarray objects from parsed metadata";
    homepage = "https://github.com/opendatacube/odc-loader/";
    changelog = "https://github.com/opendatacube/odc-loader/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ daspk04 ];
  };
}
