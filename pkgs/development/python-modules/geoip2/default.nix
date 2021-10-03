{ buildPythonPackage, lib, fetchPypi, pythonOlder
, aiohttp
, maxminddb
, mocket
, requests
, requests-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "4.3.0";
  pname = "geoip2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "599914784cea08b50fb50c22ed6a59143b5ff2d027ba782d2d5b6f3668293821";
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
