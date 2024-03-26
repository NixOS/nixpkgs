{ lib
, buildPythonPackage
, pytestCheckHook
, pythonOlder
, fetchFromGitHub
, flask
, setuptools
, simple-websocket
}:

buildPythonPackage rec {
  pname = "flask-sock";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "flask-sock";
    rev = "v${version}";
    hash = "sha256-GKfOVdeLPag2IKGCWrMjQp4NTL1/9GiyLhXhf9jQKhQ=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
    simple-websocket
  ];

  pytestFlagsArray = [
    "tests/test_flask_sock.py"
  ];

  pythonImportsCheck = [ "flask_sock" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "WebSocket support for Flask";
    homepage = "https://github.com/miguelgrinberg/flask-sock/";
    changelog = "https://github.com/miguelgrinberg/flask-sock/blob/main/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fmhoeger ];
  };
}
