{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7188b35f7874903f554b3a1a3a4465213e765c4f17182fa5cb3d9f6915da4c1";
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
    homepage = http://github.com/miguelgrinberg/Flask-SocketIO/;
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
