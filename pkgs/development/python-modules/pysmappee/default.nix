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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pysmappee";
  version = "0.2.29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "smappee";
    repo = "pysmappee";
    tag = finalAttrs.version;
    hash = "sha256-Ffi55FZsZUKDcS4qV46NpRK3VP6axzrL2BO+hYW7J9E=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
