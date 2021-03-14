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
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "pydicom";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zjpscxdhlcv99py7jx5r6dw32nzbcr49isrzkdr6g3zwyxwzbfm";
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
    "TestEchoSCP"
    "TestEchoSCPCLI"
    "TestStoreSCP"
    "TestStoreSCPCLI"
    "TestStoreSCU"
    "TestStoreSCUCLI"
    "TestQRGetServiceClass"
    "TestQRMoveServiceClass"
  ];

  pythonImportsCheck = [ "pynetdicom" ];

  meta = with lib; {
    description = "Python implementation of the DICOM networking protocol";
    homepage = "https://github.com/pydicom/pynetdicom";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Tests are not passing on Darwin, thus it's assumed that it doesn't work
    broken = stdenv.isDarwin;
  };
}
