{ buildPythonPackage, lib, fetchPypi, isPy27
, ipaddress
, maxminddb
, mock
, requests
, requests-mock
}:

buildPythonPackage rec {
  version = "4.0.2";
  pname = "geoip2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4afb5d899eac08444e461239c8afb165c90234adc0b5dc952792d9da74c9091b";
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
