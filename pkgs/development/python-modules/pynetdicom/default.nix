{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pydicom,
  pyfakefs,
  pytestCheckHook,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "3.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pynetdicom";
    tag = "v${version}";
    hash = "sha256-4LISckHH+fVBmPcBr8rM62E6r3IkKAgdUneVHyc5Vm8=";
  };

  build-system = [ flit-core ];

  dependencies = [ pydicom ];

  nativeCheckInputs = [
    pyfakefs
    pytestCheckHook
    sqlalchemy
  ];

  disabledTests = [
    # Some tests needs network capabilities
    "test_str_types_empty"
    "test_associate_reject"
    "TestAEGoodAssociation"
    "TestEchoSCP"
    "TestEchoSCPCLI"
    "TestEventHandlingAcceptor"
    "TestEventHandlingRequestor"
    "TestFindSCP"
    "TestFindSCPCLI"
    "TestGetSCP"
    "TestGetSCPCLI"
    "TestMoveSCP"
    "TestMoveSCPCLI"
    "TestPrimitive_N_GET"
    "TestQRGetServiceClass"
    "TestQRMoveServiceClass"
    "TestSearch"
    "TestState"
    "TestStorageServiceClass"
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
  ];

  disabledTestPaths = [
    # Ignore apps tests
    "pynetdicom/apps/tests/"
  ];

  pythonImportsCheck = [ "pynetdicom" ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    changelog = "https://github.com/pydicom/pynetdicom/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
