{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "v${version}";
    sha256 = "01zf6cy95pgc4flgn0740z2my90l7rxwliahp6rb2xbp7rh32cng";
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
