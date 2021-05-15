{ lib
, bidict
, buildPythonPackage
, fetchFromGitHub
, mock
, pytestCheckHook
, python-engineio_3
}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "v${version}";
    sha256 = "14dijag17v84v0pp9qi89h5awb4h4i9rj0ppkixqv6is9z9lflw5";
  };

  propagatedBuildInputs = [
    bidict
    python-engineio_3
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "socketio" ];

  # pytestCheckHook seems to change the default log level to WARNING, but the
  # tests assert it is ERROR
  disabledTests = [ "test_logger" ];

  meta = with lib; {
    description = "Python Socket.IO server and client 4.x";
    longDescription = ''
      Socket.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-socketio/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ graham33 ];
  };
}
