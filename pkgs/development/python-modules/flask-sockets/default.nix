{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, gevent
, gevent-websocket
}:

buildPythonPackage rec {
  pname = "Flask-Sockets";
  version = "0.2.1";

  src = fetchFromGitHub {
     owner = "heroku-python";
     repo = "flask-sockets";
     rev = "v0.2.1";
     sha256 = "0k63x380gpjjr5j3bmkzsa1qp9gaq1jrm5ai2fnpqw459g1y4bwq";
  };

  propagatedBuildInputs = [
    flask
    gevent
    gevent-websocket
  ];

  # upstream doesn't have any tests, single file
  doCheck = false;

  pythonImportsCheck = [
    "flask_sockets"
  ];

  meta = with lib; {
    description = "Elegant WebSockets for your Flask apps";
    homepage = "https://github.com/heroku-python/flask-sockets";
    license = licenses.mit;
    maintainers = [ maintainers.prusnak ];
  };
}
