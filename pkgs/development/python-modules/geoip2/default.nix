{ buildPythonPackage, lib, fetchPypi, isPy27
, aiohttp
, maxminddb
, mock
, mocket
, requests
, requests-mock
}:

buildPythonPackage rec {
  version = "4.1.0";
  pname = "geoip2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "57d8d15de2527e0697bbef44fc16812bba709f03a07ef99297bd56c1df3b1efd";
  };

  patchPhase = ''
    substituteInPlace requirements.txt --replace "requests>=2.24.0,<3.0.0" "requests"
  '';

  propagatedBuildInputs = [ aiohttp requests maxminddb ];

  checkInputs = [ mocket requests-mock ];

  meta = with lib; {
    description = "MaxMind GeoIP2 API";
    homepage = "https://www.maxmind.com/en/home";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
