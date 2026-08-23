{
  lib,
  brotli,
  buildPythonPackage,
  cargo,
  execnet,
  fetchFromGitHub,
  jinja2,
  pytestCheckHook,
  pytest-rerunfailures,
  pyzmq,
  redis,
  rustc,
  rustPlatform,
  setuptools,
  setuptools-rust,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "logbook";
  version = "1.9.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getlogbook";
    repo = "logbook";
    tag = finalAttrs.version;
    hash = "sha256-/oaBUIMsDwyxjQU57BpwXQfDMBNSDAI7fqtem/4QqKw=";
  };

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xIjcK69rwtE86DfvD9qXEn8MDIvU0Dl+d4Fmw9BUuCM=";
  };

  optional-dependencies = {
    execnet = [ execnet ];
    sqlalchemy = [ sqlalchemy ];
    redis = [ redis ];
    zmq = [ pyzmq ];
    compression = [ brotli ];
    jinja = [ jinja2 ];
    all = [
      brotli
      execnet
      jinja2
      pyzmq
      redis
      sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-rerunfailures
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "logbook" ];

  disabledTests = [
    # Test require Redis instance
    "test_redis_handler"
  ];

  meta = {
    description = "Logging replacement for Python";
    homepage = "https://logbook.readthedocs.io/";
    changelog = "https://github.com/getlogbook/logbook/blob/${finalAttrs.src.tag}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
