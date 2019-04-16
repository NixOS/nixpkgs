{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "3.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee8e2954ec3ae0abf19f50fce5ec8b7b9ff937c5353c0a72c7e1cfb86df1195d";
  };

  propagatedBuildInputs = [
    flask
    python-socketio
  ];

  checkInputs = [ coverage ];
  # tests only on github, but lates release there is not tagged
  doCheck = false;

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = https://github.com/miguelgrinberg/Flask-SocketIO/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
