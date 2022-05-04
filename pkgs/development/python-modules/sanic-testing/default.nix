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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-testing";
    rev = "v${version}";
    sha256 = "17fbb78gvic5s9nlcgwj817fq1f9j9d1d7z6n2ahhinmvyzl9gc8";
  };

  outputs = [
    "out"
    "testsout"
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "httpx>=0.18,<0.22" "httpx"
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
