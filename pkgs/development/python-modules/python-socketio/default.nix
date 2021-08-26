{ lib
, bidict
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, python-engineio
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "v${version}";
    sha256 = "sha256-jyTTWxShLDDnbT+MYIJIjwpn3xfIB04je78doIOG+FQ=";
  };

  propagatedBuildInputs = [
    bidict
    python-engineio
  ];

  checkInputs = [
    mock
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
