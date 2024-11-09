{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  gdcm,
  nibabel,
  numpy,
  pydicom,
  pylibjpeg,
  pylibjpeg-libjpeg,
  scipy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.4.11";
  pyproject = true;

  disabled = pythonOlder "3.6";

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-/JauQZcCQDl1ukcSE3YPbf1SyhVxDNJUlqnFwdlwYQY=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    gdcm
    nibabel
    numpy
    pydicom
    scipy
  ];

  postPatch = ''
    substituteInPlace tests/test_generic.py --replace-fail "from common" "from dicom2nifti.common"
    substituteInPlace tests/test_ge.py --replace-fail "import convert_generic" "import dicom2nifti.convert_generic as convert_generic"
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pylibjpeg
    pylibjpeg-libjpeg
  ];

  pythonImportsCheck = [ "dicom2nifti" ];

  meta = with lib; {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    mainProgram = "dicom2nifti";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
