{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  version = "2.1.0";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "1lbpn0l796ar77amqy8dap30zxmsn6as8y2lbmp4lk8m9awscwi8";
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
