{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.2.4";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "0mpn2xbpx2r67bj5crfvxfwlznxlp7rcfbb2xly6ad3d0c7djkdi";
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
