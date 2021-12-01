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
  version = "1.5.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    sha256 = "0wr6nh0xrhzwf05gnf3dwg5r3lhn9nfwch3l16zkbj6fli871brc";
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
