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
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Kfcfk76au2ymbX+nl0PhuuCd+t6dYRbTurGlW6msv3Y=";
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
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
    "TestState"
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
