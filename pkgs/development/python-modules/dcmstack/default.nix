{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, nibabel
, pydicom
, pylibjpeg-libjpeg
}:

buildPythonPackage rec {
  pname = "dcmstack";
  version = "0.9";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "moloney";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GVzih9H2m2ZGSuZMRuaDG78b95PI3j0WQw5M3l4KNCs=";
  };

  propagatedBuildInputs = [
    nibabel
    pydicom
    pylibjpeg-libjpeg
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    homepage = "https://github.com/moloney/dcmstack";
    description = "DICOM to Nifti conversion preserving metadata";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
