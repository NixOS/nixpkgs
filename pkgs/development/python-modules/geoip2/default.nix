{ buildPythonPackage, lib, fetchPypi, isPy27
, ipaddress
, maxminddb
, mock
, requests
, requests-mock
}:

buildPythonPackage rec {
  version = "3.0.0";
  pname = "geoip2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q1ciqqd0qjkpgwsg9fws8wcqchkcq84gv2g4q3xgh2lpj3yjsaq";
  };

  propagatedBuildInputs = [ requests maxminddb ]
    ++ lib.optionals isPy27 [ ipaddress ];

  checkInputs = [ requests-mock ];

  meta = with lib; {
    description = "MaxMind GeoIP2 API";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
