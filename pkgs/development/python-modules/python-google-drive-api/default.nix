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
  version = "0.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-drive-api";
    tag = "v${version}";
    hash = "sha256-JvPaMD7UHDqCQCoh1Q8jNFw4R7Jbp2YQDBI3xVp1L1g=";
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
