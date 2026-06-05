{
  lib,
  buildPythonPackage,
  dask,
  dask-image,
  deepdiff,
  fetchFromGitHub,
  hatchling,
  importlib-resources,
  itk,
  itkwasm-downsample,
  itkwasm-image-io,
  itkwasm,
  jsonschema,
  nibabel,
  imageio,
  numpy,
  imagecodecs,
  platformdirs,
  pooch,
  psutil,
  pytestCheckHook,
  rich-argparse,
  rich,
  tensorstore,
  tifffile,
  typing-extensions,
  writableTmpDirAsHomeHook,
  zarr,
}:

buildPythonPackage (finalAttrs: {
  pname = "ngff-zarr";
  version = "0.34.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fideus-labs";
    repo = "ngff-zarr";
    tag = "py-v${finalAttrs.version}";
    hash = "sha256-5OiC1NHVEX60oHPwTJ0RN2fQnitwPBMNSfvbMcKAgvc=";
  };

  sourceRoot = "${finalAttrs.src.name}/py/";

  build-system = [ hatchling ];

  dependencies = [
    dask
    importlib-resources
    itkwasm
    itkwasm-downsample
    numpy
    platformdirs
    psutil
    rich
    rich-argparse
    typing-extensions
    zarr
  ]
  ++ dask.optional-dependencies.array;

  optional-dependencies = {
    dask-image = [ dask-image ];
    # itk = [ itk-filtering ];
    cli = [
      # itk-filtering
      # itk-io
      # liffile
      dask
      dask-image
      imagecodecs
      imageio
      itk
      itkwasm-image-io
      nibabel
      tifffile
    ]
    ++ dask.optional-dependencies.distributed;
    tensorstore = [ tensorstore ];
    validate = [ jsonschema ];
  };

  nativeCheckInputs = [
    deepdiff
    pooch
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "ngff_zarr" ];

  disabledTestPaths = [
    # No CLI tests
    "test/test_cli_input_to_ngff_image.py"
    "test/test_cli_output.py"
    "test/test_cli_relative_paths.py"
    # Attribute errors
    "test/test_pyramid_integrity.py"
    "test/test_multiscales_type.py"
    "test/test_convert_ome_zarr_version.py"
    "test/test_itk_image_to_ngff_image.py"
    # Data missing
    "test/test_hcs.py"
    "test/test_hcs_simple.py"
    "test/test_ngff_validation.py"
    "test/test_nibabel_image_to_ngff_image.py"
    # Network access
    "test/test_from_ngff_zarr_tensorstore.py"
    "test/test_from_ngff_zarr.py"
    "test/test_large_serialization.py"
    "test/test_ngff_image_to_itk_image.py"
    "test/test_omero.py"
    "test/test_rfc9_ozx.py"
    "test/test_to_ngff_zarr_dask_image.py"
    "test/test_to_ngff_zarr_itk.py"
    "test/test_to_ngff_zarr_itkwasm.py"
    "test/test_to_ngff_zarr_rfc2_zarr_v3.py"
    "test/test_to_ngff_zarr_sharding.py"
    "test/test_to_ngff_zarr_tensorstore.py"
    "test/test_to_ngff_zarr_v3_compression.py"
    # Missing dependencies
    "test/test_lif_to_ngff_image.py"
  ];

  disabledTests = [
    # Assertion errors
    "test_2d_yx"
    "test_3d_zyx"
    "test_smaller_dask_graph"
    "test_tensorstore_compression"
  ];

  meta = {
    description = "Open Microscopy Environment (OME) Next Generation File Format (NGFF) Zarr implementation";
    homepage = "https://github.com/fideus-labs/ngff-zarr";
    changelog = "https://github.com/fideus-labs/ngff-zarr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
})
