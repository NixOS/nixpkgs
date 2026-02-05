{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nibabel,
  pydicom,
  pylibjpeg,
  pint,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "dcmstack";
  version = "0.9-unstable-2024-12-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "moloney";
    repo = "dcmstack";
    rev = "68575996c8956152865e3598b15f621d7c803a96";
    hash = "sha256-QXnBtlXkxYDJFdjiqCoEuBMcHnq+87YmHX8j5EPW7HU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    nibabel
    pydicom
    pylibjpeg
    pint
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dcmstack" ];

  disabledTestPaths = [
    # AttributeError: 'TestNitoolCli' object has no attribute 'out_dir'
    "test/test_cli.py"
  ];

  meta = {
    description = "DICOM to Nifti conversion preserving metadata";
    homepage = "https://github.com/moloney/dcmstack";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
