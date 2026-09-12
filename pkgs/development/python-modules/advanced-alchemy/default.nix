{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  alembic,
  eval-type-backport,
  exceptiongroup,
  greenlet,
  rich-click,
  sqlalchemy,
  typing-extensions,
  argon2-cffi,
  cryptography,
  dogpile-cache,
  fastnanoid,
  fsspec,
  obstore,
  passlib,
  pwdlib,
  pyotp,
  uuid-utils,
  aiosqlite,
  asgi-lifespan,
  attrs,
  cattrs,
  dishka,
  fastapi,
  flask,
  flask-sqlalchemy,
  litestar,
  msgspec,
  numpy,
  pgvector,
  pydantic,
  pydantic-extra-types,
  pytest-asyncio,
  pytest-lazy-fixtures,
  pytest-mock,
  pytest-xdist,
  pytestCheckHook,
  sanic,
  sanic-ext,
  sanic-testing,
  sqlmodel,
  starlette,
  sybil,
  typer,
}:

buildPythonPackage (finalAttrs: {
  pname = "advanced-alchemy";
  version = "1.11.0";
  pyproject = true;

  __structuredAttrs = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "litestar-org";
    repo = "advanced-alchemy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mAwtgqtmCewTWK8XbGMzMqaC1s8tnTi7fSc2BTTGfdU=";
  };

  build-system = [ hatchling ];

  dependencies = [
    alembic
    greenlet
    sqlalchemy
    typing-extensions
    rich-click
  ]
  ++ lib.optionals (pythonOlder "3.10") [ eval-type-backport ]
  ++ lib.optionals (pythonOlder "3.11") [ exceptiongroup ];

  optional-dependencies = {
    argon2 = [ argon2-cffi ];
    cryptography = [ cryptography ];
    dogpile = [ dogpile-cache ];
    fsspec = [ fsspec ];
    nanoid = [ fastnanoid ];
    obstore = [ obstore ];
    passlib = [ passlib ] ++ passlib.optional-dependencies.argon2;
    pwdlib = [
      pwdlib
      argon2-cffi
    ];
    pyotp = [ pyotp ];
    uuid = [ uuid-utils ];
  };

  nativeCheckInputs = [
    aiosqlite
    argon2-cffi
    asgi-lifespan
    attrs
    cattrs
    cryptography
    dishka
    dogpile-cache
    fastapi
    flask
    flask-sqlalchemy
    fsspec
    litestar
    msgspec
    numpy
    passlib
    pgvector
    pwdlib
    pydantic
    pydantic-extra-types
    pyotp
    pytest-asyncio
    pytest-lazy-fixtures
    pytest-mock
    pytest-xdist
    pytestCheckHook
    sanic
    sanic-ext
    sanic-testing
    sqlmodel
    starlette
    sybil
    typer
    uuid-utils
  ];

  postPatch = ''
    # fsspec expects memory without a URI scheme
    substituteInPlace tests/fixtures/uuid/models.py tests/fixtures/bigint/models.py \
      --replace-fail 'register_backend("memory://", "memory")' 'register_backend("memory", "memory")'
  '';

  pythonImportsCheck = [ "advanced_alchemy" ];

  enabledTestPaths = [ "tests/unit" ];

  # Stop pytest from loading tests/conftest.py which needs Docker databases we do not have
  pytestFlags = [ "--confcutdir=tests/unit" ];

  disabledTests = [
    # Has a 1-2 second time limit that is often exceeded
    "test_model_from_dict_performance"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Ready-to-go SQLAlchemy concoctions";
    homepage = "https://advanced-alchemy.litestar.dev/latest/";
    changelog = "https://github.com/litestar-org/advanced-alchemy/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "alchemy";
    maintainers = with lib.maintainers; [ aaravrav ];
    platforms = lib.platforms.unix;
  };
})
