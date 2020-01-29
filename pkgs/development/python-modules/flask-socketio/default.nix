{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2172dff1e42415ba480cee02c30c2fc833671ff326f1598ee3d69aa02cf768ec";
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
