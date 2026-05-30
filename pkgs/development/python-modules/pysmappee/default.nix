{
  lib,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  paho-mqtt,
  pytz,
  requests,
  requests-oauthlib,
  schedule,
}:

buildPythonPackage rec {
  pname = "pysmappee";
  version = "0.2.29";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "smappee";
    repo = "pysmappee";
    rev = version;
    hash = "sha256-Ffi55FZsZUKDcS4qV46NpRK3VP6axzrL2BO+hYW7J9E=";
  };

  propagatedBuildInputs = [
    cachetools
    paho-mqtt
    pytz
    requests
    requests-oauthlib
    schedule
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysmappee" ];

  meta = {
    description = "Python Library for the Smappee dev API";
    homepage = "https://github.com/smappee/pysmappee";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
