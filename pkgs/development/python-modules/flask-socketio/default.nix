{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pytestCheckHook,
  python-socketio,
  redis,
}:

buildPythonPackage rec {
  pname = "flask-socketio";
  version = "5.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    tag = "v${version}";
    hash = "sha256-1FMAooXktrbA4FDHrS0CQuqoTV6B4xWh5IIxRTDAzLs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    flask
    python-socketio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
  ];

  enabledTestPaths = [ "test_socketio.py" ];

  pythonImportsCheck = [ "flask_socketio" ];

  meta = {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
