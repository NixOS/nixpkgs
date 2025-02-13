{
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  lib,

  # build-system
  setuptools,

  # dependencies
  gdcm,
  nibabel,
  numpy,
  pillow,
  pydicom,
  scipy,

  # tests
  pylibjpeg-libjpeg,
  pylibjpeg,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.5.1";
  pyproject = true;

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    tag = version;
    hash = "sha256-lPaBKqYO8B138fCgeKH6vpwGQhN3JCOnDj5PgaYfRPA=";
  };

  patches = [
    # Hotfix for the OverflowError in tests and package usage.
    # TODO(@osbm): Remove this patch when the upstream is fixed.
    # https://github.com/icometrix/dicom2nifti/pull/152
    (fetchpatch {
      url = "https://github.com/icometrix/dicom2nifti/pull/152/commits/dac9ff492bec6d13157e5712d774ec1ea349abff.patch";
      name = "fix-integer-scaling.patch";
      sha256 = "sha256-57t1a55sBasZzR64kUOqKzh+JiUwGWm8xMy8MN6FiaQ=";
    })
  ];

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

  meta = {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    mainProgram = "dicom2nifti";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      bcdarwin
      osbm
    ];
  };
}
