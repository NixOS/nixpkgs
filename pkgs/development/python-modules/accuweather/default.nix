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
  setuptools,
  syrupy,
}:

buildPythonPackage rec {
  pname = "accuweather";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bieniu";
    repo = "accuweather";
    tag = version;
    hash = "sha256-EM0DpFvToPgI0PSFYlJsQQ16Uh1qd0ARp1ucvUD16ss=";
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
    changelog = "https://github.com/bieniu/accuweather/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jamiemagee ];
  };
}
