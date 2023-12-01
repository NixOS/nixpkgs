{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, tqdm
, websocket-client
, pythonOlder
}:

buildPythonPackage rec {
  pname = "plexapi";
  version = "4.15.6";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = "refs/tags/${version}";
    hash = "sha256-VU1HVAxAOraTd4VQIqG/MLkw77xciCICIh1zbzGn/dQ=";
  };

  propagatedBuildInputs = [
    requests
    tqdm
    websocket-client
  ];

  # Tests require a running Plex instance
  doCheck = false;

  pythonImportsCheck = [
    "plexapi"
  ];

  meta = with lib; {
    description = "Python bindings for the Plex API";
    homepage = "https://github.com/pkkid/python-plexapi";
    changelog = "https://github.com/pkkid/python-plexapi/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
