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
  version = "4.17.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    tag = version;
    hash = "sha256-GLuTNfK8FmTx6PuvhBheYgK7ZurxvmaY1Sqxo0QKRXM=";
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

<<<<<<< HEAD
  meta = {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    changelog = "https://github.com/pkkid/python-plexapi/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    changelog = "https://github.com/pkkid/python-plexapi/releases/tag/${src.tag}";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
