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
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freekode";
    repo = "pyopenweathermap";
    # https://github.com/freekode/pyopenweathermap/issues/2
    tag = "v${version}";
    hash = "sha256-i/oqjrViATNR+HuG72ZdPMJF9TJf7B1pi+wqCth34OU=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestMarks = [
    "network"
  ];

  pythonImportsCheck = [ "pyopenweathermap" ];

  meta = with lib; {
    description = "Python library for OpenWeatherMap API for Home Assistant";
    homepage = "https://github.com/freekode/pyopenweathermap";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
