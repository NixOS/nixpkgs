{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  pythonOlder,
  isPyPy,
  fetchFromGitHub,

  # build
  cython,
  setuptools,

  # tests
  aiofiles,
  cbor2,
  httpx,
  msgpack,
  mujson,
  orjson,
  pytest-asyncio,
  pytest7CheckHook,
  pyyaml,
  rapidjson,
  requests,
  testtools,
  ujson,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "4.0.2";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "falconry";
    repo = "falcon";
    rev = "refs/tags/${version}";
    hash = "sha256-umNuHyZrdDGyrhQEG9+f08D4Wwrz6bVJ6ysw8pfbHv4=";
  };

  build-system = [ setuptools ] ++ lib.optionals (!isPyPy) [ cython ];

  __darwinAllowLocalNetworking = true;

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
    pytest7CheckHook
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
  ] ++ lib.optionals (pythonOlder "3.10") [ testtools ];

  pytestFlagsArray = [ "tests" ];

  disabledTestPaths =
    [
      # needs a running server
      "tests/asgi/test_asgi_servers.py"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # ModuleNotFoundError: No module named 'distutils'
      "tests/asgi/test_cythonized_asgi.py"
    ];

  meta = with lib; {
    changelog = "https://falcon.readthedocs.io/en/stable/changes/${version}.html";
    description = "Ultra-reliable, fast ASGI+WSGI framework for building data plane APIs at scale";
    homepage = "https://falconframework.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
