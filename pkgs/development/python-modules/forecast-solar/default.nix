{ lib
, aiodns
, aiohttp
, backports-zoneinfo
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "3.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = "refs/tags/v${version}";
    hash = "sha256-Go0DF2qyVyGVYEeoEEuxsSR9Ge8Pg4S77zM1HL83ELc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiodns
    aiohttp
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  pythonImportsCheck = [ "forecast_solar" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Asynchronous Python client for getting forecast solar information";
    homepage = "https://github.com/home-assistant-libs/forecast_solar";
    changelog = "https://github.com/home-assistant-libs/forecast_solar/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
