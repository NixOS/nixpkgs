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
  version = "5.3.7";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    rev = "refs/tags/v${version}";
    hash = "sha256-3vqhxz+NPrpjTxNt4scZtPxaFfnM3+gyE+jegwgan2E=";
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
