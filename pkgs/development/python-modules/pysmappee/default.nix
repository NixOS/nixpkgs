{ lib
, buildPythonPackage
, fetchFromGitHub
, cachetools
, paho-mqtt
, pytz
, requests
, requests_oauthlib
, schedule
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmappee";
  version = "0.2.27";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smappee";
    repo = pname;
    rev = version;
    sha256 = "sha256-CzdkeC53ye+IMeGUiD1mK84h2ruC1/ZpjlDjuWMVoyQ=";
  };

  propagatedBuildInputs = [
    cachetools
    paho-mqtt
    pytz
    requests
    requests_oauthlib
    schedule
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysmappee" ];

  meta = with lib; {
    description = "Python Library for the Smappee dev API";
    homepage = "https://github.com/smappee/pysmappee";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
