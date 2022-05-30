{ buildPythonPackage, lib, fetchPypi, pythonOlder
, aiohttp
, maxminddb
, mocket
, requests
, requests-mock
, urllib3
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "4.5.0";
  pname = "geoip2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b542252e87eb40adc3a2fc0f4e84b514c4c5e04ed46923a3a74d509f25f3103a";
  };

  patchPhase = ''
    substituteInPlace requirements.txt --replace "requests>=2.24.0,<3.0.0" "requests"
  '';

  propagatedBuildInputs = [ aiohttp maxminddb requests urllib3 ];

  checkInputs = [
    mocket
    requests-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "geoip2" ];

  meta = with lib; {
    description = "GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
