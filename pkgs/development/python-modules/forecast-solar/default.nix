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
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = version;
    sha256 = "sha256-UrLy+j8YDWuS9pciEDKb/+UoCcw54XWiIUAEYC72/W0=";
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
