{ lib
, buildPythonPackage
, coverage
, fetchFromGitHub
, flask
, pytestCheckHook
, python-socketio
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "5.3.3";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "v${version}";
    hash = "sha256-oqy6tSk569QaSkeNsyXuaD6uUB3yuEFg9Jwh5rneyOE=";
  };

  propagatedBuildInputs = [
    flask
    python-socketio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
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
