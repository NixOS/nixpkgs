{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, gdcm
, nibabel
, numpy
, pydicom
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.4.8";
  disabled = pythonOlder "3.6";

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    rev = version;
    hash = "sha256-2Pspxdeu3pHwXpbjS6bQQnvdeMuITRwYarPuLlmNcv8";
  };

  propagatedBuildInputs = [ gdcm nibabel numpy pydicom scipy setuptools ];

  # python-gdcm just builds the python interface provided by the "gdcm" package, so
  # we should be able to replace "python-gdcm" with "gdcm" but this doesn't work
  # (similar to https://github.com/NixOS/nixpkgs/issues/84774)
  postPatch = ''
    substituteInPlace setup.py --replace "python-gdcm" ""
    substituteInPlace tests/test_generic.py --replace "from common" "from dicom2nifti.common"
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dicom2nifti" ];

  meta = with lib; {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
