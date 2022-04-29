{ lib
, buildPythonPackage
, coverage
, fetchFromGitHub
, flask
, pytestCheckHook
, python-socketio
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "v${version}";
    sha256 = "sha256-PnNJEtcWaisOlt6OmYUl97TlZb9cK2ORvtEcmGPxSB0=";
  };

  propagatedBuildInputs = [
    flask
    python-socketio
  ];

  checkInputs = [
    coverage
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "test_socketio.py"
  ];

  pythonImportsCheck = [ "flask_socketio" ];

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
