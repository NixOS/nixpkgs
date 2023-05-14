{ lib
, buildPythonPackage
, pythonOlder
, isPyPy
, fetchFromGitHub

# build
, cython
, setuptools

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
  version = "3.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5Lhz4qI/x7yK9tqQg4CvYNug+fp9l6ErNGH1pVybZ6c=";
  };

  nativeBuildInputs = [
    setuptools
  ] ++ lib.optionals (!isPyPy) [
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

  nativeCheckInputs = [
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
