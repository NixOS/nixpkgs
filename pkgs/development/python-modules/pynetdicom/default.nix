{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pydicom
, pyfakefs
, pytestCheckHook
, sqlalchemy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "2.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/JWQUtFBW4uqCbs/nUxj1pRBfTCXV4wcqTkqvzpdFrM=";
  };

  patches = [
    (fetchpatch {
      name = "fix-python-3.11-test-attribute-errors";
      url = "https://github.com/pydicom/pynetdicom/pull/754/commits/2126bd932d6dfb3f07045eb9400acb7eaa1b3069.patch";
      hash = "sha256-t6Lg0sTZSWIE5q5pkBvEoHDQ+cklDn8SgNBcFk1myp4=";
     })
  ];

  propagatedBuildInputs = [
    pydicom
  ];

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

  pythonImportsCheck = [
    "pynetdicom"
  ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Tests are not passing on Darwin/Aarch64, thus it's assumed that it doesn't work
    broken = stdenv.isDarwin || stdenv.isAarch64;
  };
}
