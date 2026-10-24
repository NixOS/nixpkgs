{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  numpy,
  pydantic,
  pydantic-zarr,
  zarr,

  # tests
  aiohttp,
  fsspec,
  pytest-cov-stub,
  pytest-doctestplus,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ome-zarr-models";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ome-zarr-models";
    repo = "ome-zarr-models-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yC62hrlv3OOSXp6c3et3ZRa51iMHQkyXv1W7eyJCxlM=";
  };

  pythonRelaxDeps = [ "pydantic" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    numpy
    pydantic
    pydantic-zarr
    zarr
  ];

  pythonImportsCheck = [ "ome_zarr_models" ];

  nativeCheckInputs = [
    aiohttp
    fsspec
    pytest-cov-stub
    pytest-doctestplus
    pytest-vcr
    pytestCheckHook
  ];

  pytestFlags = [ "--override-ini=testpaths=tests" ];

  disabledTests = [
    # Require internet connection
    "test_bioformats2raw_get_image"
    "test_load_remote_data"
    # AssertionError
    "test_get_all_zarrs"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # pydantic.errors.PydanticUserError: `Image` is not fully defined; you should define all
    # referenced types, then call `Image.model_rebuild()`.
    "test_datasets"
    "test_example_hcs"
    "test_from_zarr_ectopic_group"
    "test_from_zarr_missing_array"
    "test_global_transform"
    "test_image"
    "test_multiscale_group_ectopic_group"
    "test_multiscale_group_missing_arrays"
    "test_new_image"
    "test_no_global_transform"
    "test_non_existent_wells"
    "test_non_existent_wells_from_zarr"
    "test_well"

    # RuntimeError: Could not successfully validate
    # <Group file:///build/source/tests/data/examples/v04/hcs_example.ome.zarr> against any OME-Zarr
    # group model
    "test_cli_validate"
    "test_load_ome_zarr_group"
  ];

  meta = {
    description = "Minimal Python package for reading, writing and validating OME-Zarr (meta)data";
    homepage = "https://ome-zarr-models-py.readthedocs.io/en/stable";
    downloadPage = "https://github.com/ome-zarr-models/ome-zarr-models-py";
    changelog = "https://github.com/ome-zarr-models/ome-zarr-models-py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
