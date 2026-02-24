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
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tronikos";
    repo = "python-google-weather-api";
    tag = "v${version}";
    hash = "sha256-5ljKaIwG78oufb0iRaqTY46wxelAiuQUvhmRbZWo5Fk=";
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
