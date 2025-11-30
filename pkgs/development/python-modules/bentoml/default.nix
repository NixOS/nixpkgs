{
  lib,
  stdenv,
  a2wsgi,
  aiohttp,
  aiosqlite,
  attrs,
  buildPythonPackage,
  cattrs,
  circus,
  click-option-group,
  click,
  cloudpickle,
  deepmerge,
  fetchFromGitHub,
  fs-s3fs,
  fs,
  fsspec,
  grpcio-channelz,
  grpcio-health-checking,
  grpcio-reflection,
  grpcio,
  hatch-vcs,
  hatchling,
  httpx-ws,
  httpx,
  inflection,
  inquirerpy,
  jinja2,
  kantoku,
  numpy,
  nvidia-ml-py,
  opentelemetry-api,
  opentelemetry-exporter-otlp-proto-http,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-asgi,
  opentelemetry-instrumentation-grpc,
  opentelemetry-instrumentation,
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
  pythonOlder,
  pyyaml,
  questionary,
  rich,
  rich-toolkit,
  schema,
  simple-di,
  starlette,
  tomli-w,
  tomli,
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
  writableTmpDirAsHomeHook,
}:

let
  version = "1.4.29";
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
    triton = [
      tritonclient
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux (
      tritonclient.optional-dependencies.http ++ tritonclient.optional-dependencies.grpc
    );
  };

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "BentoML";
    tag = "v${version}";
    hash = "sha256-humzefKjnFpbWp9QVcUGPD0+3l2bOyFA35reZLtwFt4=";
  };
in
buildPythonPackage {
  pname = "bentoml";
  inherit version src;
  pyproject = true;

  pythonRelaxDeps = [
    "cattrs"
    "fsspec"
    "nvidia-ml-py"
    "opentelemetry-api"
    "opentelemetry-instrumentation-aiohttp-client"
    "opentelemetry-instrumentation-asgi"
    "opentelemetry-instrumentation"
    "opentelemetry-sdk"
    "opentelemetry-semantic-conventions"
    "opentelemetry-util-http"
    "rich-toolkit"
  ];

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    a2wsgi
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
    fsspec
    httpx
    httpx-ws
    inflection
    inquirerpy
    jinja2
    kantoku
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
    questionary
    rich
    rich-toolkit
    schema
    simple-di
    starlette
    tomli-w
    uv
    uvicorn
    watchfiles
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

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
    "tests/unit/grpc"
    "tests/unit/_internal/"
  ];

  disabledTests = [
    # flaky test
    "test_store"
    #
    "test_log_collection"
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
    writableTmpDirAsHomeHook
  ]
  ++ optional-dependencies.grpc;

  meta = with lib; {
    description = "Build Production-Grade AI Applications";
    homepage = "https://github.com/bentoml/BentoML";
    changelog = "https://github.com/bentoml/BentoML/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      natsukium
    ];
  };
}
