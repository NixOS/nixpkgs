{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  anyio,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-tornado,
  pytestCheckHook,
  pytz,
  setuptools_80,
  setuptools-scm,
  tornado,
  tzlocal,

  # optional-dependencies
  etcd3,
  protobuf,
  gevent,
  kazoo,
  rethinkdb,
  twisted,
  pymongo,
  redis,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "apscheduler";
  version = "3.11.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "apscheduler";
    tag = finalAttrs.version;
    hash = "sha256-a1EeDOMYH9O5tRBQigZSLp6kBPp81+6biI0s0N79Sck=";
  };

  patches = [
    ./pytz-compat.patch
  ];

  postPatch = ''
    sed -i "/addopts/d" pyproject.toml
  '';

  build-system = [
    setuptools_80
    setuptools-scm
  ];

  dependencies = [
    tzlocal
  ];

  optional-dependencies = {
    etcd = [
      etcd3
      protobuf
    ];
    gevent = [ gevent ];
    mongodb = [ pymongo ];
    redis = [ redis ];
    rethinkdb = [ rethinkdb ];
    sqlalchemy = [ sqlalchemy ];
    tornado = [ tornado ];
    twisted = [ twisted ];
    zookeeper = [ kazoo ];
  };

  nativeCheckInputs = [
    anyio
    gevent
    pytest-asyncio
    pytest-cov-stub
    pytest-tornado
    pytestCheckHook
    pytz
    tornado
    twisted
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    "test_broken_pool"
    # gevent tests have issue on newer Python releases
    "test_add_live_job"
    "test_add_pending_job"
    "test_shutdown"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_submit_job"
    "test_max_instances"
  ];

  disabledTestPaths = [
    # too many database requirements
    "tests/test_jobstores.py"
  ];

  pythonImportsCheck = [ "apscheduler" ];

  meta = {
    changelog = "https://github.com/agronholm/apscheduler/releases/tag/${finalAttrs.src.tag}";
    description = "Library that lets you schedule your Python code to be executed";
    homepage = "https://github.com/agronholm/apscheduler";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
