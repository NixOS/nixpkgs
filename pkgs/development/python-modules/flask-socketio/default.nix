{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  flask,
  pytestCheckHook,
  python-socketio,
<<<<<<< HEAD
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  redis,
}:

buildPythonPackage rec {
  pname = "flask-socketio";
<<<<<<< HEAD
  version = "5.6.0";
  pyproject = true;
=======
  version = "5.5.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1FMAooXktrbA4FDHrS0CQuqoTV6B4xWh5IIxRTDAzLs=";
  };

  build-system = [ setuptools ];

  dependencies = [
=======
    hash = "sha256-C/eNyvAfyu2oTBZUFvDhTZqyyB+aohAHDNzShqbD4O4=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    flask
    python-socketio
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
  ];

  enabledTestPaths = [ "test_socketio.py" ];

  pythonImportsCheck = [ "flask_socketio" ];

<<<<<<< HEAD
  meta = {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
=======
  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/${src.tag}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
