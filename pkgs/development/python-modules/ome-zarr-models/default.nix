{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  pydantic,
  pydantic-zarr,
  zarr,

  # tests
  aiohttp,
  fsspec,
  pytest-cov-stub,
  pytest-vcr,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ome-zarr-models";
  version = "1.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ome-zarr-models";
    repo = "ome-zarr-models-py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lEzYP4AcEV6EtE+E8yqNHJPIPJ0RwWtzm77fcdxYGYk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pydantic
    pydantic-zarr
    zarr
  ];

  pythonImportsCheck = [ "ome_zarr_models" ];

  nativeCheckInputs = [
    aiohttp
    fsspec
    pytest-cov-stub
    pytest-vcr
    pytestCheckHook
  ];

  disabledTests = [
    # Require internet connection
    "test_bioformats2raw_get_image"
    "test_load_remote_data"
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
