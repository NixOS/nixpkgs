{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, setuptools
=======
, coverage
, fetchFromGitHub
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flask
, pytestCheckHook
, python-socketio
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "Flask-SocketIO";
<<<<<<< HEAD
  version = "5.3.6";
  format = "pyproject";
=======
  version = "5.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "Flask-SocketIO";
<<<<<<< HEAD
    rev = "refs/tags/v${version}";
    hash = "sha256-YjCe34Mvt7tvp3w5yH52lrq4bWi7aIYAUssNqxlQ8CA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

=======
    rev = "v${version}";
    hash = "sha256-oqy6tSk569QaSkeNsyXuaD6uUB3yuEFg9Jwh5rneyOE=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  pythonImportsCheck = [
    "flask_socketio"
  ];
=======
  pythonImportsCheck = [ "flask_socketio" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Socket.IO integration for Flask applications";
    homepage = "https://github.com/miguelgrinberg/Flask-SocketIO/";
<<<<<<< HEAD
    changelog = "https://github.com/miguelgrinberg/Flask-SocketIO/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
=======
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
