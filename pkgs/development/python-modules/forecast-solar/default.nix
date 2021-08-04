{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, aiodns
, aiohttp
, backports-zoneinfo
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = version;
    sha256 = "12d9bb3q7gp0yy152x0rcbi727wrg3w9458asp2nhnqlb8nm6j4d";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  # no unit tests implemented
  doCheck = false;

  pythonImportsCheck = [ "forecast_solar" ];

  meta = with lib; {
    description = "Asynchronous Python client for getting forecast solar information";
    homepage = "https://github.com/home-assistant-libs/forecast_solar";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
