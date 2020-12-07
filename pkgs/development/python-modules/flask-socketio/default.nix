{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "37001b3507f2fa5d1c8d9c8e211dd88da6c5286ff0ebce16f27cb1b467d25d68";
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
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
