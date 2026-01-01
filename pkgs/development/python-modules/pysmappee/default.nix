{
  lib,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  paho-mqtt,
  pythonOlder,
  pytz,
  requests,
  requests-oauthlib,
  schedule,
}:

buildPythonPackage rec {
  pname = "pysmappee";
  version = "0.2.29";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Python Library for the Smappee dev API";
    homepage = "https://github.com/smappee/pysmappee";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python Library for the Smappee dev API";
    homepage = "https://github.com/smappee/pysmappee";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
