{
  lib,
  buildPythonPackage,
  pythonAtLeast,
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
  pytest7CheckHook,
  pyyaml,
  rapidjson,
  requests,
  ujson,
  uvicorn,
  websockets,
}:

buildPythonPackage rec {
  pname = "falcon";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "falconry";
    repo = "falcon";
    tag = version;
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
    aiofiles
    httpx
    uvicorn
    websockets

    # handler specific
    cbor2
    msgpack
    mujson
    ujson
  ];

  enabledTestPaths = [ "tests" ];

  disabledTestPaths = [
    # needs a running server
    "tests/asgi/test_asgi_servers.py"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # ModuleNotFoundError: No module named 'distutils'
    "tests/asgi/test_cythonized_asgi.py"
  ];

  meta = {
    changelog = "https://falcon.readthedocs.io/en/stable/changes/${version}.html";
    description = "Ultra-reliable, fast ASGI+WSGI framework for building data plane APIs at scale";
    homepage = "https://falconframework.org/";
    license = lib.licenses.asl20;
  };
}
