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
  version = "22.3.0";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "v${version}";
    sha256 = "sha256-ZsLQA8rP4RrbVSUy5n0WZs903fnF7jtFqrIe5JVuRIg=";
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
