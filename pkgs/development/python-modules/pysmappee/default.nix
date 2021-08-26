{ lib
, buildPythonPackage
, fetchFromGitHub
, cachetools
, paho-mqtt
, pytz
, requests
, requests_oauthlib
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysmappee";
  version = "0.2.25";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smappee";
    repo = pname;
    rev = version;
    sha256 = "0ld3pb86dq61fcvr6zigdz1vjjcwf7izzkajyg82nmb508a570d7";
  };

  propagatedBuildInputs = [
    cachetools
    paho-mqtt
    pytz
    requests
    requests_oauthlib
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
