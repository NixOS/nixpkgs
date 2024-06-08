{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  bidict,
  python-engineio,

  # optional-dependencies
  aiohttp,
  requests,
  websocket-client,

  # tests
  msgpack,
  pytestCheckHook,
  simple-websocket,
  uvicorn,

}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.11.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "refs/tags/v${version}";
    hash = "sha256-t5QbuXjipLaf9GV+N5FLq45xJPK2/FUaM/0s8RNPTzo=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    bidict
    python-engineio
  ];

  passthru.optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [ aiohttp ];
  };

  nativeCheckInputs = [
    msgpack
    pytestCheckHook
    uvicorn
    simple-websocket
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "socketio" ];

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
