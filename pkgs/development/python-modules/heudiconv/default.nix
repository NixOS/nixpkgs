{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
, datalad
, git
, dcm2niix
, nibabel
, pydicom
, nipype
, dcmstack
, etelemetry
, filelock
}:

buildPythonPackage rec {
  version = "0.13.1";
  pname = "heudiconv";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UUBRC6RToj4XVbJnxG+EKdue4NVpTAW31RNm9ieF1lU=";
  };

  propagatedBuildInputs = [
    nibabel
    pydicom
    nipype
    dcmstack
    etelemetry
    filelock
  ];

  nativeCheckInputs = [
    datalad
    dcm2niix
    pytestCheckHook
    git
  ];

  preCheck = ''export HOME=$(mktemp -d)'';

  meta = with lib; {
    homepage = "https://heudiconv.readthedocs.io";
    description = "Flexible DICOM converter for organizing imaging data";
    changelog = "https://github.com/nipy/heudiconv/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
