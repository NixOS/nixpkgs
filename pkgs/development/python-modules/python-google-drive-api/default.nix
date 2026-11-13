{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytest-aiohttp,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "python-google-drive-api";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-drive-api";
    tag = "v${version}";
    hash = "sha256-AKeuD22lSvouYHeTnQsl6sBEP7ZB6SyH+5hhquS1Ffk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "google_drive_api" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Python client library for Google Drive API";
    homepage = "https://github.com/tronikos/python-google-drive-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
