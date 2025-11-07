{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-google-drive-api";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-drive-api";
    tag = "v${version}";
    hash = "sha256-3es2rmndahH+DMEEwjBxyZKd27qDZIocPbzScF7B5fA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "google_drive_api" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python client library for Google Drive API";
    homepage = "https://github.com/tronikos/python-google-drive-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
