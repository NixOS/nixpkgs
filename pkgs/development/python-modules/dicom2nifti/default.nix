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
}:

buildPythonPackage rec {
  pname = "dicom2nifti";
  version = "2.2.8";
  disabled = isPy27;

  # no tests in PyPI dist
  src = fetchFromGitHub {
    owner = "icometrix";
    repo = pname;
    rev = version;
    sha256 = "1qi2map6f4pa1l8wsif7ff7rhja6ynrjlm7w306dzvi9l25mia34";
  };

  propagatedBuildInputs = [ gdcm nibabel numpy pydicom scipy ];

  checkInputs = [ nose gdcm ];
  checkPhase = "nosetests tests";

  meta = with lib; {
    homepage = "https://github.com/icometrix/dicom2nifti";
    description = "Library for converting dicom files to nifti";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
