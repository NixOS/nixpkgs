{
  lib,
  buildPythonPackage,
  fetchPypi,
  freezegun,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ftputil";
  version = "5.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2IK6UcUDXPio+zMkCDYHVgbXYp5FasS9DoDA2jge720=";
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
