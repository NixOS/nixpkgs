{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  replaceVars,
  writableTmpDirAsHomeHook,
  writeShellScriptBin,

  aiosqlite,
  alembic,
  amplitude-analytics,
  anyio,
  apprise,
  asgi-lifespan,
  asyncpg,
  boto3,
  cachetools,
  click,
  cloudpickle,
  coolname,
  cryptography,
  cyclopts,
  dateparser,
  docker,
  exceptiongroup,
  fastapi,
  fsspec,
  graphviz,
  griffe,
  hatchling,
  httpcore,
  httpx,
  humanize,
  jinja2-humanize-extension,
  jinja2,
  jsonpatch,
  jsonschema,
  moto,
  numpy,
  opentelemetry-api,
  opentelemetry-distro,
  opentelemetry-exporter-otlp,
  opentelemetry-instrumentation,
  opentelemetry-instrumentation-logging,
  opentelemetry-instrumentation-system-metrics,
  opentelemetry-sdk,
  opentelemetry-test-utils,
  orjson,
  packaging,
  pathspec,
  pendulum,
  pluggy,
  prometheus-client,
  pydantic-core,
  pydantic-extra-types,
  pydantic-settings,
  pydantic,
  pydocket,
  pytest-asyncio,
  pytest-env,
  pytest-timeout,
  pytest-xdist,
  python-dateutil,
  python-on-whales,
  python-slugify,
  pytz,
  pyyaml,
  readchar,
  respx,
  rfc3339-validator,
  rich,
  ruamel-yaml-clib,
  ruamel-yaml,
  semver,
  sniffio,
  sqlalchemy,
  toml,
  typing-extensions,
  uv,
  uvicorn,
  versioningit,
  watchfiles,
  websockets,
  whenever,
  yamllint,
}:

buildPythonPackage (finalAttrs: {
  pname = "prefect";
  version = "3.6.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PrefectHQ";
    repo = "prefect";
    tag = finalAttrs.version;
    hash = "sha256-3OyRIaQktaIUqgkcbvtbw3knMnQH0T58dByKLwd4nwQ=";
  };

  patches = [
    (replaceVars ./development_base_path.patch {
      inherit (finalAttrs) src;
    })

    (replaceVars ./version.patch {
      inherit (finalAttrs) version;
    })
  ];

  # wanted by hatchling
  nativeBuildInputs = [
    (writeShellScriptBin "git" "false")
  ];

  build-system = [
    hatchling
    versioningit
  ];

  dependencies = [
    aiosqlite
    alembic
    apprise
    asyncpg
    click
    cryptography
    cyclopts
    dateparser
    docker
    jinja2
    jinja2-humanize-extension
    pytz
    readchar
    sqlalchemy
    # client dependencies
    amplitude-analytics
    anyio
    asgi-lifespan
    cachetools
    cloudpickle
    coolname
    exceptiongroup
    fastapi
    fsspec
    graphviz
    griffe
    httpcore
    httpx
    humanize
    jsonpatch
    jsonschema
    opentelemetry-api
    orjson
    packaging
    pathspec
    pluggy
    prometheus-client
    pydantic
    pydantic-core
    pydantic-extra-types
    pydantic-settings
    pydocket
    python-dateutil
    python-slugify
    pyyaml
    rfc3339-validator
    rich
    ruamel-yaml
    ruamel-yaml-clib
    semver
    sniffio
    toml
    typing-extensions
    uvicorn
    websockets
  ]
  ++ sqlalchemy.optional-dependencies.asyncio
  ++ httpx.optional-dependencies.http2
  ++ lib.optional (pythonOlder "3.13") pendulum
  ++ lib.optional (pythonAtLeast "3.13") whenever;

  optional-dependencies = {
    aws = [
      # prefect-aws
    ];
    azure = [
      # prefect-azure
    ];
    bitbucket = [
      # prefect-bitbucket
    ];
    buildx = [
      python-on-whales
    ];
    bundles = [
      uv
    ];
    dask = [
      # prefect-dask
    ];
    databricks = [
      # prefect-databricks
    ];
    dbt = [
      # prefect-dbt
    ];
    docker = [
      # prefect-docker
    ];
    email = [
      # prefect-email
    ];
    gcp = [
      # prefect-gcp
    ];
    github = [
      # prefect-github
    ];
    gitlab = [
      # prefect-gitlab
    ];
    kubernetes = [
      # prefect-kubernetes
    ];
    otel = [
      opentelemetry-distro
      opentelemetry-exporter-otlp
      opentelemetry-instrumentation
      opentelemetry-instrumentation-logging
      opentelemetry-instrumentation-system-metrics
      opentelemetry-test-utils
    ];
    ray = [
      # prefect-ray
    ];
    redis = [
      # prefect-redis
    ];
    shell = [
      # prefect-shell
    ];
    slack = [
      # prefect-slack
    ];
    snowflake = [
      # prefect-snowflake
    ];
    sqlalchemy = [
      # prefect-sqlalchemy
    ];
  };

  passthru.tests = {
    inherit (nixosTests) prefect;

    updateScript = nix-update-script {
      extraArgs = [
        # avoid pre‐releases
        "--version-regex"
        "^(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  # FIXME: build killed at ~30%
  doCheck = false;
  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook

    boto3
    moto
    numpy
    opentelemetry-sdk
    opentelemetry-test-utils
    pytest-asyncio
    pytest-env
    pytest-timeout
    pytest-xdist
    respx
    uv
    uvicorn
    watchfiles
    yamllint
  ];

  meta = {
    description = "Workflow orchestration framework for building resilient data pipelines in Python";
    homepage = "https://github.com/PrefectHQ/prefect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      happysalada
      mrmebelman
    ];
    mainProgram = "prefect";
  };
})
