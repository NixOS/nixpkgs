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
  pname = "python-google-weather-api";
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-weather-api";
    tag = "v${version}";
    hash = "sha256-Vbiw2fbSGBIBmM8siRSTSjt64ZM7k/HFv/V66dzY6B0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  pythonImportsCheck = [ "google_weather_api" ];

  nativeCheckInputs = [
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
