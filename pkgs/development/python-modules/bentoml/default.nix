{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  inflection,
  jinja2,
  numpy,
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
  nvidia-ml-py,
  python-dateutil,
  python-json-logger,
  python-multipart,
  pyyaml,
  requests,
  rich,
  schema,
  simple-di,
  starlette,
  uvicorn,
  watchfiles,
  fs-s3fs,
  grpcio,
  grpcio-health-checking,
  opentelemetry-instrumentation-grpc,
  protobuf,
  grpcio-channelz,
  grpcio-reflection,
  filetype,
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
  scikit-learn,
  lxml,
  orjson,
  pytest-asyncio,
  fastapi,
}:

let
  version = "1.2.5";
  aws = [ fs-s3fs ];
  grpc = [
    grpcio
    grpcio-health-checking
    opentelemetry-instrumentation-grpc
    protobuf
  ];
  io-file = [ filetype ];
  io-image = io-file ++ [ pillow ];
  io-json = [ pydantic ];
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
  io = io-json ++ io-image ++ io-pandas ++ io-file;
  tracing = tracing-otlp; # ++ tracing-zipkin ++ tracing-jaeger
  optional-dependencies = {
    all = aws ++ io ++ grpc ++ grpc-reflection ++ grpc-channelz ++ tracing ++ monitor-otlp;
    inherit
      aws
      grpc
      io-file
      io-image
      io-json
      io-pandas
      io
      grpc-reflection
      grpc-channelz
      monitor-otlp
      tracing-otlp
      tracing
      ;
    triton =
      [
        tritonclient
      ]
      ++ tritonclient.optional-dependencies.http
      ++ tritonclient.optional-dependencies.grpc;
  };
in
buildPythonPackage {
  pname = "bentoml";
  inherit version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "BentoML";
    rev = "refs/tags/v${version}";
    hash = "sha256-GBKxyjCs02mxYiMK4GhgFUATRCUSVf8mFbWjuPVD7SU=";
  };

  # https://github.com/bentoml/BentoML/pull/4227 should fix this test
  postPatch = ''
    substituteInPlace tests/unit/_internal/utils/test_analytics.py \
      --replace "requests" "httpx"
  '';

  pythonRelaxDeps = [ "opentelemetry-semantic-conventions" ];

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
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
    inflection
    jinja2
    numpy
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
    nvidia-ml-py
    python-dateutil
    python-json-logger
    python-multipart
    pyyaml
    requests
    rich
    schema
    simple-di
    starlette
    uvicorn
    watchfiles
  ];

  passthru.optional-dependencies = optional-dependencies;

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
    pytestCheckHook
    pandas
    pydantic
    scikit-learn
    lxml
    orjson
    pytest-asyncio
    pillow
    fastapi
    starlette
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
    # https://github.com/bentoml/BentoML/issues/3885
    broken = versionAtLeast pydantic.version "2";
  };
}
