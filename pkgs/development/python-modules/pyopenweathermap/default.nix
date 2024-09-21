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
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freekode";
    repo = "pyopenweathermap";
    rev = "refs/tags/v${version}";
    hash = "sha256-4wpV04yooZfgcu60PcpmEBtCSa2oONegjz0RS9WSYL4=";
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
