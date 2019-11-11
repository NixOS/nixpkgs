{ buildPythonPackage, lib, fetchPypi, isPy27
, ipaddress
, maxminddb
, mock
, requests
, requests-mock
}:

buildPythonPackage rec {
  version = "2.9.0";
  pname = "geoip2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1w7cay5q6zawjzivqbwz5cqx1qbdjw6kbriccb7l46p7b39fkzzp";
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
