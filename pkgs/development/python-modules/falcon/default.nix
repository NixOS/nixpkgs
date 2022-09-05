{ lib
, buildPythonPackage
, pythonOlder
, isPyPy
, fetchFromGitHub

# build
, cython

# tests
, aiofiles
, cbor2
, httpx
, msgpack
, mujson
, orjson
, pytest-asyncio
, pytestCheckHook
, pyyaml
, rapidjson
, requests
, testtools
, ujson
, uvicorn
, websockets
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "3.1.0";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = version;
    hash = "sha256-Y6bD0GCXhqpvMV+/i1v59p2qWZ91f2ey7sPQrVALY54=";
  };

  nativeBuildInputs = lib.optionals (!isPyPy) [
    cython
  ];

  preCheck = ''
    export HOME=$TMPDIR
    cp -R tests examples $TMPDIR
    pushd $TMPDIR
  '';

  postCheck = ''
    popd
  '';

  checkInputs = [
    # https://github.com/falconry/falcon/blob/master/requirements/tests
    pytestCheckHook
    pyyaml
    requests
    rapidjson
    orjson

    # ASGI specific
    pytest-asyncio
    aiofiles
    httpx
    uvicorn
    websockets

    # handler specific
    cbor2
    msgpack
    mujson
    ujson
  ] ++ lib.optionals (pythonOlder "3.10") [
    testtools
  ];

  pytestFlagsArray = [
    "tests"
  ];

  disabledTestPaths = [
    # needs a running server
    "tests/asgi/test_asgi_servers.py"
  ];

  meta = with lib; {
    description = "An unladen web framework for building APIs and app backends";
    homepage = "https://falconframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };

}
