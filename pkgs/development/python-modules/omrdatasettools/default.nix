{ lib
, fetchPypi
, buildPythonPackage
, pytest
, pillow
, scikitimage
, h5py
, pyhamcrest
, muscima
, mung
, numpy
, lxml
, tqdm
, twine
, sympy
, sphinx_rtd_theme
, pandas
, ipython
}:

buildPythonPackage rec {
  pname = "omrdatasettools";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cdq02jp8vh78yjq9bncjjl0pb554idrcxkd62rzwk4l6ss2fkw5";
  };

  propagatedBuildInputs = [
    pillow
    scikitimage
    h5py
    pyhamcrest
    muscima
    mung
    numpy
    lxml
    tqdm
    twine
    sympy
    sphinx_rtd_theme
    pandas
    ipython
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest omrdatasettools/ -s -k 'not ${lib.concatStringsSep " and not " disabledTests}'
  '';

  disabledTests = [
    # The download tests require internet access
    "test_download_extract_and_crop_bitmaps"
    "test_download_and_extract_bargheer_edirom_dataset_expect_folder_to_be_created"
    "test_download_and_extract_freischuetz_edirom_dataset_expect_folder_to_be_created"
    "test_download_of_audiveris_dataset"
    "test_download_of_baro_dataset"
    "test_download_of_capitan_dataset"
    "test_download_of_deepscores_dataset"
    "test_download_of_fornes_dataset"
    "test_download_of_homus_v1_dataset"
    "test_download_of_homus_v2_dataset"
    "test_download_of_measure_bounding_box_annotations_v1"
    "test_download_of_measure_bounding_box_annotations_v2"
    "test_download_of_muscima_pp_measure_annotations"
    "test_download_of_muscima_pp_v1_dataset"
    "test_download_of_muscima_pp_v1_images"
    "test_download_of_muscima_pp_v2_dataset"
    "test_download_of_muscima_pp_v2_images"
    "test_download_of_openomr_dataset"
    "test_download_of_printed_symbols_dataset"
    "test_download_of_rebelo1_dataset"
    "test_download_extract_and_render_all_symbols"
    "test_download_of_rebelo2_dataset"
    "test_download_extract_and_draw_bitmaps"
    # Other failures
    "test_render_node_masks_instance_segmentation_of_staff_blobs"
    "test_render_node_masks_instance_segmentation_of_staff_lines"
    "test_render_node_masks_semantic_segmentation_of_nodes"
  ];

  meta = with lib; {
    description = "Collection of datasets used for Optical Music Recognition";
    homepage = "https://github.com/apacha/omr-datasets";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
