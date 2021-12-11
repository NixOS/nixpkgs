{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-limiter
, markupsafe
, decorator
, itsdangerous
, raven
, six
, brotlipy
}:

buildPythonPackage rec {
  pname = "httpbin";
  version = "0.7.0";

  src = fetchFromGitHub {
     owner = "kennethreitz";
     repo = "httpbin";
     rev = "v0.7.0";
     sha256 = "1r9zcccsibp98844nb439zkd89q6795v6rl5wgsczndh27hpdcdj";
  };

  propagatedBuildInputs = [ brotlipy flask flask-limiter markupsafe decorator itsdangerous raven six ];

  # No tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/kennethreitz/httpbin";
    description = "HTTP Request & Response Service";
    license = licenses.mit;
  };
}
