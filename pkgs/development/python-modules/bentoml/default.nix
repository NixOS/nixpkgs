{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pythonRelaxDepsHook,
  hatchling,
  hatch-vcs,
  aiohttp,
  attrs,
  cattrs,
  circus,
  click,
  click-option-group,
  cloudpickle,
  deepmerge,
  fs,
  httpx,
  httpx-ws,
  inflection,
  jinja2,
  numpy,
  nvidia-ml-py,
  opentelemetry-api,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-aiohttp-client,
  opentelemetry-instrumentation-asgi,
  opentelemetry-sdk,
  opentelemetry-semantic-conventions,
  opentelemetry-util-http,
  packaging,
  pathspec,
  pip-requirements-parser,
  pip-tools,
  prometheus-client,
  psutil,
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
  uvicorn,
  watchfiles,
  fs-s3fs,
  grpcio,
  grpcio-health-checking,
  opentelemetry-instrumentation-grpc,
  protobuf,
  grpcio-channelz,
  grpcio-reflection,
  pillow,
  pydantic,
  pandas,
  pyarrow,
  opentelemetry-exporter-otlp-proto-http,
  # https://pypi.org/project/opentelemetry-exporter-jaeger-proto-grpc/
  # , opentelemetry-exporter-jaeger # support for this exporter ends in july 2023
  opentelemetry-exporter-otlp,
  # , opentelemetry-exporter-zipkin
  tritonclient,
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
  version = "1.2.18";
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
  monitor-otlp = [ opentelemetry-exporter-otlp-proto-http ];
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
    hash = "sha256-giZteSikwS9YEcVMPCC9h2khbBgvUPRW1biAyixO13Y=";
  };

  nativeBuildInputs = [ pythonRelaxDepsHook ];

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
    pip-tools
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
