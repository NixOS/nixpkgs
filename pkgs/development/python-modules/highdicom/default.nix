{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  numpy,
  pillow,
  pillow-jpls,
  pydicom,
  pylibjpeg,
  pylibjpeg-libjpeg,
  setuptools,
}:

let
  test_data = fetchFromGitHub {
    owner = "pydicom";
    repo = "pydicom-data";
    rev = "cbb9b2148bccf0f550e3758c07aca3d0e328e768";
    hash = "sha256-nF/j7pfcEpWHjjsqqTtIkW8hCEbuQ3J4IxpRk0qc1CQ=";
  };
in
buildPythonPackage rec {
  pname = "highdicom";
  version = "0.23.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "MGHComputationalPathology";
    repo = "highdicom";
    tag = "v${version}";
    hash = "sha256-LrsG85/bpqIEP++LgvyaVyw4tMsuUTtHNwWl7apuToM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    pillow
    pillow-jpls
    pydicom
  ];

  optional-dependencies = {
    libjpeg = [
      pylibjpeg
      pylibjpeg-libjpeg
      #pylibjpeg-openjpeg  # broken on aarch64-linux
    ];
  };

  pythonRemoveDeps = [
    "pyjpegls" # not directly used
  ];

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.libjpeg;
  preCheck = ''
    export HOME=$TMP/test-home
    mkdir -p $HOME/.pydicom/
    ln -s ${test_data}/data_store/data $HOME/.pydicom/data
  '';

  disabledTests = [
    # require pyjpegls
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

  meta = with lib; {
    description = "High-level DICOM abstractions for Python";
    homepage = "https://highdicom.readthedocs.io";
    changelog = "https://github.com/ImagingDataCommons/highdicom/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
