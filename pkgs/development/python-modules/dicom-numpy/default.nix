{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, pydicom
}:

buildPythonPackage rec {
  pname = "dicom-numpy";
  version = "0.6.3";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "innolitics";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QIPuSFaWgHmcTddZ8H9kgzLYuwGUzy/FVsi/ttSUskA=";
  };

  propagatedBuildInputs = [
    numpy
    pydicom
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dicom_numpy"
  ];

  meta = with lib; {
    description = "Read DICOM files into Numpy arrays";
    homepage = "https://github.com/innolitics/dicom-numpy";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
