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
<<<<<<< HEAD
  version = "4.15.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";
=======
  version = "4.13.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "pkkid";
    repo = "python-plexapi";
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-mxVj98wbstUx/Abim7kzVVt/8kaAPVOhv4zt+PFgi3Y=";
=======
    hash = "sha256-yq1tQ6xJn+IxrKXwUVeLhki6sdkwzu9hHSILsLJdPPY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
