{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
  tqdm,
  websocket-client,
}:

buildPythonPackage rec {
  pname = "plexapi";
  version = "4.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    tag = version;
    hash = "sha256-iRUrIb3pknT92Pk6jdkQzE1pWx85i+T31Yy+Wt8Q7bQ=";
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

  meta = {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    changelog = "https://github.com/pkkid/python-plexapi/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
