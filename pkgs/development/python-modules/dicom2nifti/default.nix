{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, gdcm
, nose
, nibabel
, numpy
, pydicom
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.2.12";
  disabled = isPy27;

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    rev = version;
    sha256 = "0ddzaw0yasyi2wsh7a6r73cdcmdfbb0nh0k0n4yxp9vnkw1ag5z4";
  };

  propagatedBuildInputs = [ nibabel numpy pydicom scipy setuptools ];

  checkInputs = [ nose gdcm ];
  checkPhase = "nosetests tests";

  meta = with lib; {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
