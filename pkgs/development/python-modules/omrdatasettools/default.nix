{
  lib,
  buildPythonPackage,
  fetchPypi,
  h5py,
  ipython,
  lxml,
  mung,
  muscima,
  numpy,
  pillow,
  pytestCheckHook,
  scikit-image,
  sphinx-rtd-theme,
  sympy,
  pandas,
  pyhamcrest,
  tqdm,
  twine,
}:

buildPythonPackage rec {
  pname = "omrdatasettools";
  version = "1.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-kUUcbti29uDnSEvCubMAUnptlaZGpEsW2IBGSAGnGyQ=";
  };

  propagatedBuildInputs = [
    pillow
    scikit-image
    h5py
    pyhamcrest
    muscima
    mung
    numpy
    lxml
    tqdm
    twine
    sympy
    sphinx-rtd-theme
    pandas
    ipython
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # The download tests require internet access
    "omrdatasettools/tests/test_downloader.py"
  ];

  disabledTests = [
    # The download tests require internet access
    "test_download_extract_and_crop_bitmaps"
    "test_download_extract_and_render_all_symbols"
    "test_download_extract_and_draw_bitmaps"
    # Other failures
    "test_render_node_masks_instance_segmentation_of_staff_blobs"
    "test_render_node_masks_instance_segmentation_of_staff_lines"
    "test_render_node_masks_semantic_segmentation_of_nodes"
  ];

  meta = with lib; {
    description = "Collection of datasets used for Optical Music Recognition";
    homepage = "https://github.com/apacha/OMR-Datasets";
    changelog = "https://github.com/apacha/OMR-Datasets/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
