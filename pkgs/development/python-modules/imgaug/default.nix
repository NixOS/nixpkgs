{ buildPythonPackage
, fetchFromGitHub
, imageio
, imagecorruptions
, numpy
, opencv3
, pytestCheckHook
, scikitimage
, scipy
, shapely
, six
, lib
}:

buildPythonPackage rec {
  pname = "imgaug";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "aleju";
    repo = "imgaug";
    rev = version;
    sha256 = "17hbxndxphk3bfnq35y805adrfa6gnm5x7grjxbwdw4kqmbbqzah";
  };

  postPatch = ''
    substituteInPlace requirements.txt \
      --replace "opencv-python-headless" ""
    substituteInPlace setup.py \
      --replace "opencv-python-headless" ""
    substituteInPlace pytest.ini \
      --replace "--xdoctest --xdoctest-global-exec=\"import imgaug as ia\nfrom imgaug import augmenters as iaa\"" ""
  '';

  propagatedBuildInputs = [
    imageio
    imagecorruptions
    numpy
    opencv3
    scikitimage
    scipy
    shapely
    six
  ];

  checkInputs = [
    opencv3
    pytestCheckHook
  ];

  disabledTests = [
    # Tests are outdated
    "test_quokka_segmentation_map"
    "test_pool"
    "test_avg_pool"
    "test_max_pool"
    "test_min_pool"
    "est_median_pool"
    "test_alpha_is_080"
    "test_face_and_lines_at_half_visibility"
    "test_polygon_fully_inside_image__no_rectangular_shape"
    # flaky due to timing-based assertions
    "test_imap_batches_output_buffer_size"
    "test_imap_batches_unordered_output_buffer_size"
  ];

  disabledTestPaths = [
    # TypeError:  int() argument must be a string, a bytes-like object or a number, not 'NoneType'
    "test/augmenters/test_pooling.py"
  ];

  pythonImportsCheck = [ "imgaug" ];

  meta = with lib; {
    homepage = "https://github.com/aleju/imgaug";
    description = "Image augmentation for machine learning experiments";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai rakesh4g ];
    platforms = platforms.linux;
    # Scikit-image 0.19 update broke API, see https://github.com/scikit-image/scikit-image/releases/tag/v0.19.0
    # and https://github.com/scikit-image/scikit-image/issues/6093
    broken = lib.versionAtLeast scikitimage.version "0.19";
  };
}
