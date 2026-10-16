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
  pname = "python-google-weather-api";
  version = "0.0.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-weather-api";
    tag = "v${version}";
    hash = "sha256-1vTE1fOYi8/bAuDX4RRVEthjRW0ADZCh8skvcspU/I4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "google_weather_api" ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tronikos/python-google-weather-api/releases/tag/${src.tag}";
    description = "Python client library for the Google Weather API";
    homepage = "https://github.com/tronikos/python-google-weather-api";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
