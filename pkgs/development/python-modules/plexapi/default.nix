{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
  tqdm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "plexapi";
  version = "4.17.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    tag = version;
    hash = "sha256-/CYWoEHmev5e5ZmlaBms1zclRwzvugAuG2JXzK9MeZA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    tqdm
    websocket-client
  ];

  # Tests require a running Plex instance
  doCheck = false;

  pythonImportsCheck = [ "plexapi" ];

  meta = with lib; {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    changelog = "https://github.com/pkkid/python-plexapi/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
