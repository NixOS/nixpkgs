{ lib
, buildPythonPackage
, fetchFromGitHub
, pycountry
, pythonOlder
, requests
, websocket-client
, xmltodict
}:

buildPythonPackage rec {
  pname = "pyskyqremote";
  version = "0.2.49";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RogerSelwyn";
    repo = "skyq_remote";
    rev = version;
    sha256 = "sha256-Xhr+p/kIp3Sm7swqCsjXHaECntwJnBLyGlcSg2lsxZc=";
  };

  propagatedBuildInputs = [
    pycountry
    requests
    websocket-client
    xmltodict
  ];

  # Project has no tests, only a test script which looks like anusage example
  doCheck = false;

  pythonImportsCheck = [
    "pyskyqremote"
  ];

  meta = with lib; {
    description = "Python module for accessing SkyQ boxes";
    homepage = "https://github.com/RogerSelwyn/skyq_remote";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
