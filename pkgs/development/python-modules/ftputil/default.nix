{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, freezegun
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "ftputil";
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6eYtP9MH75xS5Dsz/ZJ1n8lMBNi1F4+F9kGxg5BtQ1M=";
  };

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTests = [
    # Tests require network access
    "test_public_servers"
    "test_real_ftp"
    "test_set_parser"
    "test_upload"
  ];

  pythonImportsCheck = [
    "ftputil"
  ];

  meta = with lib; {
    description = "High-level FTP client library (virtual file system and more)";
    homepage = "https://ftputil.sschwarzer.net/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ];
  };
}
