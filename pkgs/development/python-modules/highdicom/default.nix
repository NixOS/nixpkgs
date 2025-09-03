{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  numpy,
  pillow,
  pydicom,
  pylibjpeg,
  pylibjpeg-libjpeg,
  pylibjpeg-openjpeg,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "highdicom";
  version = "0.26.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "MGHComputationalPathology";
    repo = "highdicom";
    tag = "v${version}";
    hash = "sha256-zaa0daGMQHktYkG56JA2a7s5UZSv8AbinO5roe9rWQc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pillow
    pydicom
    typing-extensions
  ];

  optional-dependencies = {
    libjpeg = [
      pylibjpeg
      pylibjpeg-libjpeg
      pylibjpeg-openjpeg
    ];
  };

  pythonRemoveDeps = [
    "pyjpegls" # not directly used
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.libjpeg;
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${pydicom.passthru.pydicom-data}/data_store/data $HOME/.pydicom/data
  '';

  disabledTests = [
    # require pyjpegls
    "test_construction_10"
    "test_jpegls_monochrome"
    "test_jpegls_rgb"
    "test_jpeglsnearlossless_monochrome"
    "test_jpeglsnearlossless_rgb"
    "test_multi_frame_sm_image_ushort_encapsulated_jpegls"
    "test_monochrome_jpegls"
    "test_monochrome_jpegls_near_lossless"
    "test_rgb_jpegls"
    "test_construction_autotile"
    "test_pixel_types_fractional"
    "test_pixel_types_labelmap"
  ];

  pythonImportsCheck = [
    "highdicom"
    "highdicom.legacy"
    "highdicom.ann"
    "highdicom.ko"
    "highdicom.pm"
    "highdicom.pr"
    "highdicom.seg"
    "highdicom.sr"
    "highdicom.sc"
  ];

  meta = {
    description = "High-level DICOM abstractions for Python";
    homepage = "https://highdicom.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/highdicom/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
