{ lib
, aiohttp
, bidict
, buildPythonPackage
, fetchFromGitHub
, mock
, msgpack
, pytestCheckHook
, python-engineio
, pythonOlder
, requests
, websocket-client
}:

buildPythonPackage rec {
  pname = "python-socketio";
<<<<<<< HEAD
  version = "5.9.0";
=======
  version = "5.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-1lyTZwkRpGRbeBqt6Thv5o+bUzkD1sC3T9T1GbWMEkI=";
=======
    hash = "sha256-3Do3Ql48cmhvrFe14ZYvWH0xi3T8hJ2LP0FyyWin580=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    bidict
    python-engineio
  ];

  passthru.optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [
      aiohttp
    ];
  };

  nativeCheckInputs = [
    mock
    msgpack
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "socketio"
  ];

  meta = with lib; {
    description = "Python Socket.IO server and client";
    longDescription = ''
      Socket.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-socketio/";
    changelog = "https://github.com/miguelgrinberg/python-socketio/blob/v${version}/CHANGES.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ mic92 ];
  };
}
