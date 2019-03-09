{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.2.5";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "0ixgq1rr3s60bmrwx8qwvlvs3lag1c2nrmg4iy7wcmb8i1ddylqr";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ asgiref autobahn twisted ];

  checkInputs = [ hypothesis pytest pytest-asyncio ];

  doCheck = !stdenv.isDarwin; # most tests fail on darwin

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
