{
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  lib,
  python-engineio-v3,
  requests,
  setuptools,
  six,
  websocket-client,
  websockets,
}:

buildPythonPackage rec {
  pname = "python-socketio-v4";
  version = "4.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3VzLPYT4p4Uh2U4DMpxu6kq1NPZXlOqWOljLOe0bM40=";
  };

  build-system = [ setuptools ];

  dependencies = [
    python-engineio-v3
    six
  ];

  optional-dependencies = {
    client = [
      requests
      websocket-client
    ];
    asyncio_client = [
      aiohttp
      websockets
    ];
  };

  pythonImportsCheck = [ "socketio_v4" ];

  # no tests on PyPI
  doCheck = false;

  meta = {
    description = "Socket.IO server";
    homepage = "https://github.com/bdraco/python-socketio-v4";
    license = lib.licenses.mit;
    longDescription = "This is a release of 4.6.1 under the “socketio_v4” namespace for old systems.";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
