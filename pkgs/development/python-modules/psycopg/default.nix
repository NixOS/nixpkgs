{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchurl,
<<<<<<< HEAD
  pythonOlder,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "3.3.2";
  pyproject = true;
=======
  version = "3.2.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "psycopg";
    repo = "psycopg";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-ynzXQkTnCCkJK3EZrGHSpzgMeeX92U6+08m8QtNfAc4=";
=======
    hash = "sha256-g1mms12EqRiln5dK/BmBa9dd9duSPRgRIiZkVmSRaYI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    inherit version pyproject src;
=======
    inherit version src;
    format = "pyproject";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_c
<<<<<<< HEAD

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
=======
    '';

    nativeBuildInputs = [
      cython
      libpq.pg_config
      setuptools
      tomli
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    inherit version pyproject src;
=======
    inherit version src;
    format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_pool
    '';

<<<<<<< HEAD
    build-system = [ setuptools ];

    dependencies = [ typing-extensions ];
=======
    propagatedBuildInputs = [ typing-extensions ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    # tested in psycopg
    doCheck = false;

    meta = baseMeta // {
      description = "Connection Pool for Psycopg";
    };
  };
in

buildPythonPackage rec {
<<<<<<< HEAD
  inherit
    pname
    version
    pyproject
    src
    ;
=======
  inherit pname version src;
  pyproject = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  build-system = [ setuptools ];

  # building the docs fails with the following error when cross compiling
  #  AttributeError: module 'psycopg_c.pq' has no attribute '__impl__'
  nativeBuildInputs = lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
=======
  nativeBuildInputs = [
    setuptools
  ]
  # building the docs fails with the following error when cross compiling
  #  AttributeError: module 'psycopg_c.pq' has no attribute '__impl__'
  ++ lib.optionals (stdenv.hostPlatform == stdenv.buildPlatform) [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
