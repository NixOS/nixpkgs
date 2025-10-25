{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

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
  pytest7CheckHook,
  redis,
  simple-websocket,
  uvicorn,
  valkey,

}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.14.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    tag = "v${version}";
    hash = "sha256-aZuu/FePpW2jsizg+xD7RyL/DQWkuaopaQpiCygcH58=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bidict
    python-engineio
  ];

  optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [ aiohttp ];
  };

  nativeCheckInputs = [
    msgpack
    pytest7CheckHook
    redis
    simple-websocket
    uvicorn
    valkey
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pythonImportsCheck = [ "socketio" ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Use fixed ports which leads to failures when building concurrently
    "tests/async/test_admin.py"
    "tests/common/test_admin.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Python Socket.IO server and client";
    longDescription = ''
      Socket.IO is a lightweight transport protocol that enables real-time
      bidirectional event-based communication between clients and a server.
    '';
    homepage = "https://github.com/miguelgrinberg/python-socketio/";
    changelog = "https://github.com/miguelgrinberg/python-socketio/blob/${src.tag}/CHANGES.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
