{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pydicom
, pyfakefs
, pytestCheckHook
, sqlalchemy
}:

buildPythonPackage rec {
  pname = "pynetdicom";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    sha256 = "09v0bp9zgwbs4zwcncvfccrna5rnihkhs3l4qy0f1lq8gnzjg365";
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
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
    "TestState"
  ];

  pythonImportsCheck = [ "pynetdicom" ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Tests are not passing on Darwin/Aarch64, thus it's assumed that it doesn't work
    broken = stdenv.isDarwin || stdenv.isAarch64;
  };
}
