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
  version = "5.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    tag = "v${version}";
    hash = "sha256-C/eNyvAfyu2oTBZUFvDhTZqyyB+aohAHDNzShqbD4O4=";
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

  enabledTestPaths = [ "test_socketio.py" ];

  pythonImportsCheck = [ "flask_socketio" ];

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/${src.tag}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
  };
}
