{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  aiohttp,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyopenweathermap";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freekode";
    repo = "pyopenweathermap";
    # https://github.com/freekode/pyopenweathermap/issues/2
    rev = "refs/tags/v${version}";
    hash = "sha256-OGalKlZP4pKKWKypjM5nVesvFAGLgvvRjMWzrEIp+VQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-m"
    "'not network'"
  ];

  pythonImportsCheck = [ "pyopenweathermap" ];

  meta = with lib; {
    description = "Python library for OpenWeatherMap API for Home Assistant";
    homepage = "https://github.com/freekode/pyopenweathermap";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
