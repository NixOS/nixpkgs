{ stdenv, buildPythonPackage, isPy3k, fetchFromGitHub
, asgiref, autobahn, twisted, pytestrunner
, hypothesis, pytest, pytest-asyncio
}:
buildPythonPackage rec {
  pname = "daphne";
  name = "${pname}-${version}";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13jv8jn8nf522smwpqdy4lq6cpd06fcgwvgl67i622rid51fj5gb";
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
