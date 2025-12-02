{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
  pythonOlder,
  replaceVars,

  # build
  libpq,
  setuptools,

  # propagates
  typing-extensions,

  # psycopg-c
  cython,
  tomli,

  # docs
  furo,
  shapely,
  sphinxHook,
  sphinx-autodoc-typehints,

  # tests
  anyio,
  pproxy,
  pytest-randomly,
  pytestCheckHook,
  postgresql,
  postgresqlTestHook,
}:

let
  pname = "psycopg";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "psycopg";
    repo = "psycopg";
    tag = version;
    hash = "sha256-X4gpknLotZ1RmWaTdY6I7w+unSJMc56UI1Ddi7edGSg=";
  };

  patches = [
    (replaceVars ./ctypes.patch {
      libpq = "${libpq}/lib/libpq${stdenv.hostPlatform.extensions.sharedLibrary}";
      libc = "${stdenv.cc.libc}/lib/libc.so.6";
    })
  ];

  baseMeta = {
    changelog = "https://github.com/psycopg/psycopg/blob/${version}/docs/news.rst#current-release";
    homepage = "https://github.com/psycopg/psycopg";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ hexa ];
  };

  psycopg-c = buildPythonPackage {
    pname = "${pname}-c";
    inherit version pyproject src;

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_c

      substituteInPlace pyproject.toml \
        --replace-fail "setuptools ==" "setuptools >="
    '';

    build-system = [
      cython
      setuptools
    ]
    ++ lib.optional (pythonOlder "3.11") [
      tomli
    ];

    nativeBuildInputs = [
      libpq.pg_config
    ];

    buildInputs = [
      libpq
    ];

    # tested in psycopg
    doCheck = false;

    meta = baseMeta // {
      description = "C optimisation distribution for Psycopg";
    };
  };

  psycopg-pool = buildPythonPackage {
    pname = "${pname}-pool";
    inherit version pyproject src;

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_pool
    '';

    build-system = [ setuptools ];

    dependencies = [ typing-extensions ];

    # tested in psycopg
    doCheck = false;

    meta = baseMeta // {
      description = "Connection Pool for Psycopg";
    };
  };
in

buildPythonPackage rec {
  inherit
    pname
    version
    pyproject
    src
    ;

  outputs = [
    "out"
  ]
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    "doc"
  ];

  sphinxRoot = "../docs";

  # Introduce this file necessary for the docs build via environment var
  LIBPQ_DOCS_FILE = fetchurl {
    url = "https://raw.githubusercontent.com/postgres/postgres/496a1dc44bf1261053da9b3f7e430769754298b4/doc/src/sgml/libpq.sgml";
    hash = "sha256-JwtCngkoi9pb0pqIdNgukY8GbG5pUDZvrGAHZqjFOw4";
  };

  inherit patches;

  # only move to sourceRoot after patching, makes patching easier
  postPatch = ''
    cd psycopg
  '';

  build-system = [ setuptools ];

  # building the docs fails with the following error when cross compiling
  #  AttributeError: module 'psycopg_c.pq' has no attribute '__impl__'
  nativeBuildInputs = lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
    furo
    sphinx-autodoc-typehints
    sphinxHook
    shapely
  ];

  propagatedBuildInputs = [
    psycopg-c
    typing-extensions
  ];

  pythonImportsCheck = [
    "psycopg"
    "psycopg_c"
    "psycopg_pool"
  ];

  optional-dependencies = {
    c = [ psycopg-c ];
    pool = [ psycopg-pool ];
  };

  nativeCheckInputs = [
    anyio
    pproxy
    pytest-randomly
    pytestCheckHook
    postgresql
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux postgresqlTestHook
  ++ optional-dependencies.c
  ++ optional-dependencies.pool;

  env = {
    postgresqlEnableTCP = 1;
    PGUSER = "psycopg";
    PGDATABASE = "psycopg";
  };

  preCheck = ''
    cd ..
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    export PSYCOPG_TEST_DSN="host=/build/run/postgresql user=$PGUSER"
  '';

  disabledTests = [
    # don't depend on mypy for tests
    "test_version"
    "test_package_version"
    # expects timeout, but we have no route in the sandbox
    "test_connect_error_multi_hosts_each_message_preserved"
    # Flaky, fails intermittently
    "test_break_attempts"
    # ConnectionResetError: [Errno 104] Connection reset by peer
    "test_wait_r"
  ];

  disabledTestPaths = [
    # Network access
    "tests/test_dns.py"
    "tests/test_dns_srv.py"
    # Mypy typing test
    "tests/test_typing.py"
    "tests/crdb/test_typing.py"
  ];

  pytestFlags = [
    "-ocache_dir=.cache"
  ];

  disabledTestMarks = [
    "refcount"
    "timing"
    "flakey"
  ];

  postCheck = ''
    cd psycopg
  '';

  passthru = {
    c = psycopg-c;
    pool = psycopg-pool;
  };

  meta = baseMeta // {
    description = "PostgreSQL database adapter for Python";
  };
}
