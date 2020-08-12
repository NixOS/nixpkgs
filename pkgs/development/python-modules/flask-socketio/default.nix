{ lib
, buildPythonPackage
, fetchPypi
, flask
, python-socketio
, coverage
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "36c1d5765010d1f4e4f05b4cc9c20c289d9dc70698c88d1addd0afcfedc5b062";
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
