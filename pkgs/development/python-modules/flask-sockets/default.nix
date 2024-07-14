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
    hash = "sha256-Bykn2o7coOgeAk9Xh+ZDyH2As1G3FN6V1yO+yzDgZDs=";
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
