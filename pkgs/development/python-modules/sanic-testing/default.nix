{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  httpx,
  pythonOlder,
  sanic,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "sanic-testing";
  version = "24.6.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    tag = "v${version}";
    hash = "sha256-biUgxa0sINHAYzyKimVD8+/mPUq2dlnCl2BN+UeUaEo=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  build-system = [ setuptools ];

  dependencies = [
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
    maintainers = [ ];
  };
}
