{ lib, stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytest-runner
, hypothesis, pytest, pytest-asyncio, service-identity, pyopenssl
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "3.0.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "sha256-KWkMV4L7bA2Eo/u4GGif6lmDNrZAzvYyDiyzyWt9LeI=";
  };

  nativeBuildInputs = [ pytest-runner ];

  propagatedBuildInputs = [ asgiref autobahn twisted service-identity pyopenssl ];

  checkInputs = [ hypothesis pytest pytest-asyncio ];

  doCheck = !stdenv.isDarwin; # most tests fail on darwin

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = "https://github.com/django/daphne";
  };
}
