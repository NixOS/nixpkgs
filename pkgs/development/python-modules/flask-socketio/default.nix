{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, flask
, pytestCheckHook
, python-socketio
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
  version = "5.3.5";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "v${version}";
    hash = "sha256-5Di02VJM9sJndp/x5Hl9ztcItY3aXk/wBJT90OSoc2c=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
