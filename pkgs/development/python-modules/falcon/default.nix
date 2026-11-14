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
  msgspec,
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
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "falconry";
    repo = "falcon";
    tag = version;
    hash = "sha256-f+UoGYyrg8OZow4qONqzXuDVnrZalqUNDyavDoQ7QHE=";
  };

  build-system = [ setuptools ] ++ lib.optionals (!isPyPy) [ cython ];

  # Required by WSGI server tests that bind to localhost.
  __darwinAllowLocalNetworking = true;

  preCheck = ''
    # Prevent python -m pytest from importing Falcon from the source tree.
    export PYTHONSAFEPATH=1
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
  ]
  # msgspec does not support PyPy or Python 3.15+.
  ++ lib.optionals (!isPyPy && !pythonAtLeast "3.15") [ msgspec ];

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
    changelog = "https://falcon.readthedocs.io/en/stable/changes/${src.tag}.html";
    description = "Ultra-reliable, fast ASGI+WSGI framework for building data plane APIs at scale";
    homepage = "https://falconframework.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
