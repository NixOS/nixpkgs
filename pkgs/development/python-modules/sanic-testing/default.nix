{ lib
, buildPythonPackage
, fetchFromGitHub
, httpx
, sanic
, websockets
, callPackage
}:

buildPythonPackage rec {
  pname = "sanic-testing";
  version = "22.3.1";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-6aJyc5B9e65RPG3FwXAoQByVNdrLAWTEu2/Dqf9hf+g=";
  };

  outputs = [
    "out"
    "testsout"
  ];

  postPatch = ''
    sed -i 's/httpx>=.*"/httpx"/' setup.py
  '';

  propagatedBuildInputs = [
    httpx
    sanic
    websockets
  ];

  postInstall = ''
    mkdir $testsout
    cp -R tests $testsout/tests
  '';

  # check in passthru.tests.pytest to escape infinite recursion with sanic
  doCheck = false;
  doInstallCheck = false;

  passthru.tests = {
    pytest = callPackage ./tests.nix { };
  };

  meta = with lib; {
    description = "Core testing clients for the Sanic web framework";
    homepage = "https://github.com/sanic-org/sanic-testing";
    license = licenses.mit;
    maintainers = with maintainers; [ AluisioASG ];
  };
}
