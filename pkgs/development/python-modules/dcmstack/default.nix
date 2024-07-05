{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nibabel,
  pydicom,
  pylibjpeg-libjpeg,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dcmstack";
  version = "0.9";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "moloney";
    repo = "dcmstack";
    rev = "refs/tags/v${version}";
    hash = "sha256-GVzih9H2m2ZGSuZMRuaDG78b95PI3j0WQw5M3l4KNCs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nibabel
    pydicom
    pylibjpeg-libjpeg
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dcmstack" ];

  disabledTestPaths = [
    # AttributeError: 'TestNitoolCli' object has no attribute 'out_dir'
    "test/test_cli.py"
  ];

  meta = with lib; {
    description = "DICOM to Nifti conversion preserving metadata";
    homepage = "https://github.com/moloney/dcmstack";
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
