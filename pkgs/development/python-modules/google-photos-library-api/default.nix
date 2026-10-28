{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  mashumaro,
  pytest-aiohttp,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "google-photos-library-api";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "python-google-photos-library-api";
    tag = version;
    hash = "sha256-pmAAvwhr783ih9vpqr5DmT462z3Ug1xwHaz9itu/mt4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
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
