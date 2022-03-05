{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pydicom
, pyfakefs
, pytestCheckHook
, sqlalchemy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "2.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-28SoOdS6sAj3KrfJT8PR2k8XLEY2zh0k9w1eq1y7V8M=";
  };

  propagatedBuildInputs = [
    pydicom
  ];

  checkInputs = [
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
    "TestFindSCP"
    "TestFindSCPCLI"
    "TestGetSCP"
    "TestGetSCPCLI"
    "TestMoveSCP"
    "TestMoveSCPCLI"
    "TestQRGetServiceClass"
    "TestQRMoveServiceClass"
    "TestState"
    "TestStorageServiceClass"
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
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
