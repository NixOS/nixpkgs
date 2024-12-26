{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  hatch-vcs,
  aiohttp,
  aiosqlite,
  attrs,
  cattrs,
  circus,
  click,
  click-option-group,
  cloudpickle,
  deepmerge,
  fs,
  fs-s3fs,
  grpcio,
  grpcio-channelz,
  grpcio-health-checking,
  grpcio-reflection,
  httpx,
  httpx-ws,
  inflection,
  inquirerpy,
  jinja2,
  numpy,
  nvidia-ml-py,
  opentelemetry-api,
  opentelemetry-exporter-otlp,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-asgi,
  opentelemetry-instrumentation-grpc,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  packaging,
  pandas,
  pathspec,
  pillow,
  pip-requirements-parser,
  prometheus-client,
  protobuf,
  psutil,
  pyarrow,
  pydantic,
  python-dateutil,
  python-json-logger,
  python-multipart,
  pyyaml,
  rich,
  schema,
  simple-di,
  starlette,
  tomli,
  tomli-w,
  tritonclient,
  uv,
  uvicorn,
  watchfiles,
  # native check inputs
  pytestCheckHook,
  pytest-xdist,
  google-api-python-client,
  scikit-learn,
  lxml,
  orjson,
  pytest-asyncio,
  fastapi,
}:

let
  version = "1.3.7";
  aws = [ fs-s3fs ];
  grpc = [
    grpcio
    grpcio-health-checking
    opentelemetry-instrumentation-grpc
    protobuf
  ];
  io-image = [ pillow ];
  io-pandas = [
    pandas
    pyarrow
  ];
  grpc-reflection = grpc ++ [ grpcio-reflection ];
  grpc-channelz = grpc ++ [ grpcio-channelz ];
  monitor-otlp = [
    opentelemetry-exporter-otlp-proto-http
    opentelemetry-instrumentation-grpc
  ];
  # tracing-jaeger = [ opentelemetry-exporter-jaeger ];
  tracing-otlp = [ opentelemetry-exporter-otlp ];
  # tracing-zipkin = [ opentelemetry-exporter-zipkin ];
  io = io-image ++ io-pandas;
  tracing = tracing-otlp; # ++ tracing-zipkin ++ tracing-jaeger
  optional-dependencies = {
    all = aws ++ io ++ grpc ++ grpc-reflection ++ grpc-channelz ++ tracing ++ monitor-otlp;
    inherit
      aws
      grpc
      io-image
      io-pandas
      io
      grpc-reflection
      grpc-channelz
      monitor-otlp
      tracing-otlp
      tracing
      ;
    triton =
      [ tritonclient ]
      ++ lib.optionals stdenv.hostPlatform.isLinux (
        tritonclient.optional-dependencies.http ++ tritonclient.optional-dependencies.grpc
      );
  };
in
buildPythonPackage {
  pname = "bentoml";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "BentoML";
    rev = "refs/tags/v${version}";
    hash = "sha256-98SVW7f/Yn+NMfS6UIicQcoatMSm4XSJzbuJ0S/p3sg=";
  };

  pythonRelaxDeps = [
    "cattrs"
    "nvidia-ml-py"
    "opentelemetry-api"
    "opentelemetry-instrumentation-aiohttp-client"
    "opentelemetry-instrumentation-asgi"
    "opentelemetry-instrumentation"
    "opentelemetry-sdk"
    "opentelemetry-semantic-conventions"
    "opentelemetry-util-http"
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    aiohttp
    aiosqlite
    attrs
    cattrs
    circus
    click
    click-option-group
    cloudpickle
    deepmerge
    fs
    httpx
    httpx-ws
    inflection
    inquirerpy
    jinja2
    numpy
    nvidia-ml-py
    opentelemetry-api
    opentelemetry-instrumentation
    opentelemetry-instrumentation-aiohttp-client
    opentelemetry-instrumentation-asgi
    opentelemetry-sdk
    opentelemetry-semantic-conventions
    opentelemetry-util-http
    packaging
    pathspec
    pip-requirements-parser
    prometheus-client
    psutil
    pydantic
    python-dateutil
    python-json-logger
    python-multipart
    pyyaml
    rich
    schema
    simple-di
    starlette
    tomli-w
    uv
    uvicorn
    watchfiles
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  inherit optional-dependencies;

  pythonImportsCheck = [ "bentoml" ];

  preCheck = ''
    # required for CI testing
    # https://github.com/bentoml/BentoML/pull/4056/commits/66302b502a3f4df4e8e6643d2afefefca974073e
    export GITHUB_ACTIONS=1
  '';

  disabledTestPaths = [
    "tests/e2e"
    "tests/integration"
  ];

  disabledTests = [
    # flaky test
    "test_store"
  ];

  nativeCheckInputs = [
    fastapi
    google-api-python-client
    lxml
    orjson
    pandas
    pillow
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
    scikit-learn
  ] ++ optional-dependencies.grpc;

  meta = with lib; {
    description = "Build Production-Grade AI Applications";
    homepage = "https://github.com/bentoml/BentoML";
    changelog = "https://github.com/bentoml/BentoML/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      natsukium
    ];
    # AttributeError: 'dict' object has no attribute 'schemas'
    # https://github.com/bentoml/BentoML/issues/4290
    broken = versionAtLeast cattrs.version "23.2";
  };
}
