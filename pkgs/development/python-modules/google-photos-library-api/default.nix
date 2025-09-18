{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  google-api-python-client,
  google-auth,
  lib,
  mashumaro,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-photos-library-api";
  version = "0.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-photos-library-api";
    tag = version;
    hash = "sha256-xSwUzVwC7RPpmC9M1x/WYIaoiUlcF2h2fwiP6FYA6sw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    google-api-python-client
    google-auth
    mashumaro
  ];

  pythonImportsCheck = [ "google_photos_library_api" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/allenporter/python-google-photos-library-api/releases/tag/${version}";
    description = "Python client library for Google Photos Library API";
    homepage = "https://github.com/allenporter/python-google-photos-library-api";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
