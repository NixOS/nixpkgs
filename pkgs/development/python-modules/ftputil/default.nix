{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ftputil";
  version = "5.1.0";
  format = "setuptools";

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

  pythonImportsCheck = [ "ftputil" ];

  meta = {
    description = "High-level FTP client library (virtual file system and more)";
    homepage = "https://ftputil.sschwarzer.net/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
