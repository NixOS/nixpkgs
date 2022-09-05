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
  version = "4.12.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = "refs/tags/${version}";
    sha256 = "sha256-OzHykLpcy+ZA3jfzrDwmCoNb4JhvdHYJErzfWn+zjqo=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ colemickens ];
  };
}
