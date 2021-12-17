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
  version = "0.2.29";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smappee";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ffi55FZsZUKDcS4qV46NpRK3VP6axzrL2BO+hYW7J9E=";
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
