{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pytestCheckHook,
  python-socketio,
  pythonOlder,
  redis,
}:

buildPythonPackage rec {
  pname = "flask-socketio";
  version = "5.3.6";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "refs/tags/v${version}";
    hash = "sha256-YjCe34Mvt7tvp3w5yH52lrq4bWi7aIYAUssNqxlQ8CA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flask
    python-socketio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
  ];

  pytestFlagsArray = [ "test_socketio.py" ];

  pythonImportsCheck = [ "flask_socketio" ];

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
