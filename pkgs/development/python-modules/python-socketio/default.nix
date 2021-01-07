{ stdenv
, bidict
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, python-engineio
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "v${version}";
    sha256 = "0mpqr53mrdzk9ki24y1inpsfvjlvm7pvxf8q4d52m80i5pcd5v5q";
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

  meta = with stdenv.lib; {
    description = "Python Socket.IO server and client";
    longDescription = ''
      Socket.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-engineio/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
