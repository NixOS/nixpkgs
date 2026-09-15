{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build system
  flit-core,

  # dependencies
  click,
  lazy-model,
  pydantic,
  pymongo,
  typing-extensions,

  # test dependencies
  asgi-lifespan,
  dnspython,
  fastapi,
  httpx,
  pydantic-extra-types,
  pydantic-settings,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "beanie";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BeanieODM";
    repo = "beanie";
    tag = finalAttrs.version;
    hash = "sha256-SakJvkewlCjMp5PVwletJhvebmdgzIBDlI8GnJLrxl4=";
  };

  postPatch = ''
    # `pytest-cov` supports Python 3.13 from v7.0.0 which isn't in nixpkgs yet
    substituteInPlace pyproject.toml \
      --replace-fail 'addopts = "--cov"' ""
  '';

  build-system = [ flit-core ];

  dependencies = [
    click
    lazy-model
    pydantic
    pymongo
    typing-extensions
  ];

  optional-dependencies = {
    aws = pymongo.optional-dependencies.aws;
    encryption = pymongo.optional-dependencies.encryption;
    gssapi = pymongo.optional-dependencies.gssapi;
    ocsp = pymongo.optional-dependencies.ocsp;
    snappy = pymongo.optional-dependencies.snappy;
    zstd = pymongo.optional-dependencies.zstd;
  };

  pythonRelaxDeps = [
    "lazy-model"
  ];

  pythonImportsCheck = [ "beanie" ];

  disabledTestPaths = [
    # touches network
    "tests/fastapi"
    "tests/migrations"
    "tests/odm"
  ];

  nativeCheckInputs = [
    asgi-lifespan
    dnspython
    fastapi
    httpx
    pydantic-extra-types
    pydantic-settings
    pytest-asyncio
    pytestCheckHook
  ]
  ++ pydantic.optional-dependencies.email;

  meta = {
    changelog = "https://beanie-odm.dev/changelog";
    description = "Asynchronous Python ODM for MongoDB";
    homepage = "https://beanie-odm.dev";
    license = lib.licenses.asl20;
  };
})
