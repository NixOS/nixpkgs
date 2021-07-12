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
  version = "2.3.0";
  disabled = isPy27;

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    rev = version;
    sha256 = "sha256-QSu9CGXFjDpI25Cy6QSbrwiQ2bwsVezCUxSovRLs6AI=";
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
