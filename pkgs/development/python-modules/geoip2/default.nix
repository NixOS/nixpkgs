{ buildPythonPackage, lib, fetchPypi, pythonOlder
, aiohttp
, maxminddb
, mocket
, requests
, requests-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "4.4.0";
  pname = "geoip2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f150bed3190d543712a17467208388d31bd8ddb49b2226fba53db8aaedb8ba89";
  };

  patchPhase = ''
    substituteInPlace requirements.txt --replace "requests>=2.24.0,<3.0.0" "requests"
  '';

  propagatedBuildInputs = [ aiohttp requests maxminddb ];

  checkInputs = [
    mocket
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geoip2" ];

  meta = with lib; {
    description = "Python client for GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
