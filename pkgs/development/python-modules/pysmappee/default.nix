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
  version = "0.2.23";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "smappee";
    repo = pname;
    rev = version;
    sha256 = "sha256-vxCZzkngYnc+hD3gT1x7qAQTFjpmmgRU5F6cusNDNgk=";
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
