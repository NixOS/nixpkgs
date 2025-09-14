{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  gdcm,
  nibabel,
  numpy,
  pydicom,
  scipy,

  # tests
  pillow,
  pylibjpeg,
  pylibjpeg-libjpeg,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.6.2";
  pyproject = true;

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = "dicom2nifti";
    tag = version;
    hash = "sha256-VS1ad7sAgVWkFkTPLxzloj0dvweW5wqBlQpFqD9uZLs=";
  };

  postPatch = ''
    substituteInPlace tests/test_generic.py --replace-fail "from common" "from dicom2nifti.common"
    substituteInPlace tests/test_ge.py --replace-fail "import convert_generic" "import dicom2nifti.convert_generic as convert_generic"
  '';

  build-system = [ setuptools ];

  dependencies = [
    gdcm
    nibabel
    numpy
    pydicom
    scipy
  ];

  pythonImportsCheck = [ "dicom2nifti" ];

  nativeCheckInputs = [
    pillow
    pylibjpeg
    pylibjpeg-libjpeg
    pytestCheckHook
  ];

  disabledTests = [
    # OverflowError: Python integer -1024 out of bounds for uint16
    "test_not_a_volume"
    "test_resampling"
    "test_validate_orthogonal_disabled"

    # RuntimeError: Unable to decompress 'JPEG 2000 Image Compression (Lossless O...
    "test_anatomical"
    "test_compressed_j2k"
    "test_main_function"
    "test_rgb"

    # Missing script 'dicom2nifti_scrip'
    "test_gantry_option"
    "test_gantry_resampling"
  ];

  meta = {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    mainProgram = "dicom2nifti";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
