{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  gevent,
  gevent-websocket,
}:

buildPythonPackage rec {
  pname = "Flask-Sockets";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "072927da8edca0e81e024f5787e643c87d80b351b714de95d723becb30e0643b";
  };

  propagatedBuildInputs = [
    flask
    gevent
    gevent-websocket
  ];

  # upstream doesn't have any tests, single file
  doCheck = false;

  pythonImportsCheck = [ "flask_sockets" ];

  meta = with lib; {
    description = "Elegant WebSockets for your Flask apps";
    homepage = "https://github.com/heroku-python/flask-sockets";
    license = licenses.mit;
    maintainers = [ maintainers.prusnak ];
  };
}
