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
  version = "0.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-weather-api";
    tag = "v${version}";
    hash = "sha256-ypM6TLrDMfNnaOsL8bLT+E6J/Qxv53S9BPHsCy9qGik=";
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
