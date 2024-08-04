{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydicom,
  pyfakefs,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "2.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = "pynetdicom";
    rev = "refs/tags/v${version}";
    hash = "sha256-cEe0/mzmMnPoLQMx5AsJocGxCUVE512k9KlEmjzjzn4=";
  };

  build-system = [ poetry-core ];

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

  disabledTestPaths =
    [
      # Ignore apps tests
      "pynetdicom/apps/tests/"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/pydicom/pynetdicom/issues/924
      "pynetdicom/tests/test_assoc.py"
      "pynetdicom/tests/test_transport.py"
    ];

  pythonImportsCheck = [ "pynetdicom" ];

  pytestFlagsArray = [
    # https://github.com/pydicom/pynetdicom/issues/923
    "-W"
    "ignore::pytest.PytestRemovedIn9Warning"
  ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    changelog = "https://github.com/pydicom/pynetdicom/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
