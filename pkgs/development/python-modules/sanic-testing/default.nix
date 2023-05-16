{ lib
, buildPythonPackage
, callPackage
, fetchFromGitHub
, httpx
, pythonOlder
, sanic
, websockets
}:

buildPythonPackage rec {
  pname = "sanic-testing";
<<<<<<< HEAD
  version = "23.6.0";
=======
  version = "22.12.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-WDiEuve9P9fLHxpK0UjxhbZUmWXtP+DV7e6OT19TASs=";
=======
    hash = "sha256-pFTF2SQ9giRzPhG24FLqLPJRXaFdQ7Xi5EeltS7J3DI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  outputs = [
    "out"
    "testsout"
  ];

  propagatedBuildInputs = [
    httpx
    sanic
    websockets
  ];

  postInstall = ''
    mkdir $testsout
    cp -R tests $testsout/tests
  '';

  # Check in passthru.tests.pytest to escape infinite recursion with sanic
  doCheck = false;

  doInstallCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Core testing clients for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-testing";
    changelog = "https://github.com/sanic-org/sanic-testing/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
