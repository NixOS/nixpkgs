{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-asyncio,
  pytest-error-for-skips,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "accuweather";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "accuweather";
    rev = "refs/tags/${version}";
    hash = "sha256-7k5aA9Pm9DWjPXwsmHP6jMhnobVJpsLGPgs3YCvnzco=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-error-for-skips
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "accuweather" ];

  meta = {
    description = "Python wrapper for getting weather data from AccuWeather servers";
    homepage = "https://github.com/bieniu/accuweather";
    changelog = "https://github.com/bieniu/accuweather/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
