{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, requests
, xmltodict
}:

buildPythonPackage rec {
  pname = "meteoalertapi";
  version = "0.1.8";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rolfberkenbosch";
    repo = "meteoalert-api";
    rev = "v${version}";
    sha256 = "1l66vsd77g5hqkp2c3qrrxz4mr7liwq96apg8km80qyqsjmma9yy";
  };

  propagatedBuildInputs = [
    requests
    xmltodict
  ];

  # Tests require network access
  doCheck = false;

  pythonImportsCheck = [ "meteoalertapi" ];

  meta = with lib; {
    description = "Python wrapper for MeteoAlarm.org";
    homepage = "https://github.com/rolfberkenbosch/meteoalert-api";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
