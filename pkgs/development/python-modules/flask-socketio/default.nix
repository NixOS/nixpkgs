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
  version = "5.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    tag = "v${version}";
    hash = "sha256-tTpogVhyMNLLtK3UDOtZD2m2zIbcIAc9Opa/1xdJRa8=";
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
