{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiodns
, aiohttp
, backports-zoneinfo
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "3.0.0";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = "refs/tags/${version}";
    hash = "sha256-Go0DF2qyVyGVYEeoEEuxsSR9Ge8Pg4S77zM1HL83ELc=";
  };

  PACKAGE_VERSION = version;

  propagatedBuildInputs = [
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
