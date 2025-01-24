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
  pytestCheckHook,
  simple-websocket,
  uvicorn,

}:

buildPythonPackage rec {
  pname = "python-socketio";
  version = "5.11.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = "python-socketio";
    rev = "refs/tags/v${version}";
    hash = "sha256-iWe9IwUR+nq9SAmHzFZYUJpVOOEbc1ZdiMAjaBjQrVs=";
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
    pytestCheckHook
    uvicorn
    simple-websocket
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
    changelog = "https://github.com/miguelgrinberg/python-socketio/blob/v${version}/CHANGES.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ mic92 ];
  };
}
