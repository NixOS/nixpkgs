{
  lib,
  buildPythonPackage,
  dask-image,
  dask,
  deepdiff,
  fetchFromGitHub,
  hatchling,
  imagecodecs,
  imageio,
  importlib-resources,
  itk,
  itkwasm-downsample,
  itkwasm-image-io,
  itkwasm,
  jsonschema,
  nibabel,
  numpy,
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
  version = "0.42.1";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fideus-labs";
    repo = "ngff-zarr";
    tag = "py-v${finalAttrs.version}";
    hash = "sha256-gioxY26IPQr9f917wYm24ned1/iQyGbASlOFSwkYflE=";
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
    "test/test_itk_transform_resample_bounding_box.py"
  ];

  disabledTests = [
    # ValueError: zarr 3.2.1 < 3 is not supported
    "test_clean_tiff_emits_no_structural_warning"
    "test_multiseries_tiff_to_directory_keeps_per_series_stores"
    "test_multiseries_tiff_to_ozx_creates_requested_file"
    "test_non_rgb_multichannel_tiff_no_channel_colors"
    "test_ome_tiff_channel_colors_from_xml"
    "test_ome_tiff_rgb_s_axis_overrides_xml_colors"
    "test_pyramidal_grayscale_tiff"
    "test_pyramidal_rgb_tiff_channel_consistency"
    "test_tiff_file_to_ngff_images_2d"
    "test_tiff_file_to_ngff_images_all_series"
    "test_tiff_file_to_ngff_images_no_ome_metadata"
    "test_tiff_file_to_ngff_images_partial_ome_metadata"
    "test_tiff_file_to_ngff_images_series_all"
    "test_tiff_file_to_ngff_images_simple_rgb"
    "test_tiff_file_to_ngff_images_single_series_by_index"
    "test_tiff_file_to_ngff_images_unit_normalization"
    "test_tiff_file_to_ngff_images_unsupported_axis_warning"
    "test_tiff_file_to_ngff_images_with_channel_names"
    "test_tiff_file_to_ngff_images_with_channels"
    "test_tiff_file_to_ngff_images_with_ome_metadata"
    "test_tiff_file_to_ngff_images_with_partial_channel_names"
    "test_tiff_file_to_ngff_images_with_sample_axis"
    "test_tiff_file_to_ngff_images_without_channel_names"
    "test_tiff_sample_axis_rgba_sets_four_channel_colors"
    "test_tiff_sample_axis_sets_rgb_channel_colors"
    "test_truncated_tiff_emits_warning"

    # Assertion errors
    "test_2d_yx"
    "test_3d_zyx"
    "test_smaller_dask_graph"
    "test_tensorstore_compression"

    # Test requires network access
    "test_cli_orientation_preset_end_to_end"
    "test_cli_itk_input_writes_orientation_automatically"
  ];

  meta = {
    description = "Open Microscopy Environment (OME) Next Generation File Format (NGFF) Zarr implementation";
    homepage = "https://github.com/fideus-labs/ngff-zarr";
    changelog = "https://github.com/fideus-labs/ngff-zarr/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ fab ];
  };
})
