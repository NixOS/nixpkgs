{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
}:

buildPythonPackage rec {
  pname = "ip2location";
  version = "8.10.4";

  src = fetchFromGitHub {
    owner = "chrislim2888";
    repo = "ip2location-python";
    rev = "refs/tags/${version}";
    hash = "sha256-KQScfP+1xLx+c7dC+S0bodx6qV/86gQQGlLOc0Bn8jo=";
  };

  pythonImportsCheck = [ "IP2Location" ];

  meta = {
    description = "This is a IP2Location Python library that enables the user to find the country, region or state,
    city, latitude and longitude, ZIP code, time zone, Internet Service Provider (ISP) or company name, domain name,
    net speed, area code, weather station code, weather station name, mobile country code (MCC), mobile network code (MNC)
    and carrier brand, elevation, usage type, address type and IAB category by IP address or hostname originates from.";
    homepage = "https://github.com/chrislim2888/IP2Location-Python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gamedungeon ];
  };
}
