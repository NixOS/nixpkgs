{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.0.3";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1rdnzpgyk5cnx4xc3c7k11v2x9xpihgjpq14fib80jfpcqggw687";
  };

  nativeBuildInputs = [ pytestrunner ];

  propagatedBuildInputs = [ asgiref autobahn twisted ];

  checkInputs = [ hypothesis pytest pytest-asyncio ];

  checkPhase = ''
    # Other tests fail, seems to be due to filesystem access
    py.test -k "test_cli or test_utils"
  '';

  meta = with stdenv.lib; {
    description = "Django ASGI (HTTP/WebSocket) server";
    license = licenses.bsd3;
    homepage = https://github.com/django/daphne;
  };
}
