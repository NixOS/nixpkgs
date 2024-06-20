{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  httpx,
  pythonOlder,
  sanic,
  websockets,
}:

buildPythonPackage rec {
  pname = "sanic-testing";
  version = "23.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "refs/tags/v${version}";
    hash = "sha256-pFsGB0QDeO/iliHOitHqBIQtDlwRgFg8nhgMLsopoec=";
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
