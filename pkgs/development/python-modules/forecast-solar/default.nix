{ lib
, buildPythonPackage
, fetchFromGitHub
, aiodns
, aiohttp
}:

buildPythonPackage rec {
  pname = "forecast-solar";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "forecast_solar";
    rev = version;
    sha256 = "1kqzr1ypvdjw0zvac4spb6xdd2qpms9h8nr6vf0w9qx756ir0f95";
  };

  propagatedBuildInputs = [
    aiodns
    aiohttp
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
