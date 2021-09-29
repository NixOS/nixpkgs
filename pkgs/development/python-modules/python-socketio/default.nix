{ lib
, bidict
, buildPythonPackage
, fetchFromGitHub
, mock
, msgpack
, pytestCheckHook
, python-engineio
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "v${version}";
    sha256 = "sha256-0Q1R8XPciU5AEkj7Exlc906eyA5juYKzzA/Ygnzx7XU=";
  };

  propagatedBuildInputs = [
    bidict
    python-engineio
  ];

  checkInputs = [
    mock
    msgpack
    pytestCheckHook
  ];

  pythonImportsCheck = [ "socketio" ];

  meta = with lib; {
    description = "Python Socket.IO server and client";
    longDescription = ''
      Socket.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-socketio/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
