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
  version = "0.2.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "AEMET-OpenData";
    rev = version;
    sha256 = "0jl1897m3qmr48n469mq7d66k1j0rn7hlbcahm0ylf5i3ma03aiw";
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
