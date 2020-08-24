{ buildPythonPackage, lib, fetchPypi, isPy27
, aiohttp
, maxminddb
, mock
, mocket
, requests
, requests-mock
}:

buildPythonPackage rec {
  version = "4.0.2";
  pname = "geoip2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06q9r5sdmncj4yaxrdf0mls05jb5n6pwhf8j8r74825cks4mvysa";
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
