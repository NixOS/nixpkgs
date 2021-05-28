{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio, service-identity, pyopenssl
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.5.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "0qkhmblj3a5s3z65cgz46xsvq1b6x4m3kr6aljjnxnv7hcwib02n";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ asgiref autobahn twisted service-identity pyopenssl ];

  checkInputs = [ hypothesis pytest pytest-asyncio ];

  doCheck = !stdenv.isDarwin; # most tests fail on darwin

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = "https://github.com/django/daphne";
  };
}
