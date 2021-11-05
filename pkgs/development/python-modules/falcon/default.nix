{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiofiles
, cbor2
, httpx
, msgpack
, pecan
, pytest-asyncio
, pytestCheckHook
, pyyaml
, requests
, testtools
, websockets
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "3.0.1";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xB2E2zJYgahw6LcSnV7P2XL6QyPPd7cRmh0qIZZu5oE=";
  };

  checkInputs = [
    aiofiles
    cbor2
    httpx
    msgpack
    pecan
    pytest-asyncio
    pytestCheckHook
    pyyaml
    requests
    testtools
    websockets
  ];

  disabledTestPaths = [
    # missing optional nuts package
    "falcon/bench/nuts/nuts/tests/test_functional.py"
    # missing optional mujson package
    "tests/test_media_handlers.py"
    # tries to run uvicorn binary and doesn't find it
    "tests/asgi/test_asgi_servers.py"
  ];

  meta = with lib; {
    description = "An unladen web framework for building APIs and app backends";
    homepage = "https://falconframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };

}
