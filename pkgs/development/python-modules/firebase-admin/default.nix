{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  pythonOlder,
  aiohttp,
  cachecontrol,
  cryptography,
  google-api-python-client,
  google-cloud-firestore,
  google-cloud-storage,
  hatchling,
  http-ece,
  pyjwt,
  requests,
  setuptools,
}:

buildPythonPackage rec {

  pname = "firebase-admin";
  version = "6.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  build-system = [ hatchling ];

  src = fetchFromGitHub {
    owner = "firebase";
    repo = "firebase-admin-python";
    tag = "v${version}";
    hash = "sha256-BjYo/H5CBII9KjefhGUiEeLKBAAsnQABX+21R4pR8wE=";
  };

  dependencies = [
    aiohttp
    cachecontrol
    cryptography
    google-api-python-client
    google-cloud-firestore
    google-cloud-storage
    http-ece
    pyjwt
    requests
    setuptools
  ];

  meta = with lib; {
    description = "Firebase Admin Python SDK";
    homepage = "https://github.com/firebase/firebase-admin-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ jhahn ];
  };
}
