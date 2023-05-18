{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, geopy
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "aemet-opendata";
  version = "0.2.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "AEMET-OpenData";
    rev = "refs/tags/${version}";
    hash = "sha256-3f3hvui00oItu6t9rKecoCquqsD1Eeqz+SEsLBqGt48=";
  };

  propagatedBuildInputs = [
    geopy
    requests
    urllib3
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "aemet_opendata.interface" ];

  meta = with lib; {
    description = "Python client for AEMET OpenData Rest API";
    homepage = "https://github.com/Noltari/AEMET-OpenData";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
