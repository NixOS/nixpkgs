{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, fetchurl
, pythonOlder
, substituteAll

# build
, postgresql
, setuptools

# propagates
, backports-zoneinfo
, typing-extensions

# psycopg-c
, cython_3
, tomli

# docs
, furo
, shapely
, sphinxHook
, sphinx-autodoc-typehints

# tests
, anyio
, pproxy
, pytest-randomly
, pytestCheckHook
, postgresqlTestHook
}:

let
  pname = "psycopg";
  version = "3.1.14";

  src = fetchFromGitHub {
    owner = "psycopg";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zocRBnrQoJDWI4qhxDnxxIeiLdaWolvsujqfHBYQc/A=";
  };

  patches = [
    (substituteAll {
      src = ./ctypes.patch;
      libpq = "${postgresql.lib}/lib/libpq${stdenv.hostPlatform.extensions.sharedLibrary}";
      libc = "${stdenv.cc.libc}/lib/libc.so.6";
    })

    (fetchpatch {
      # add fixture to mark flaky ref count tests
      url = "https://github.com/psycopg/psycopg/commit/70ef364324ba3448ef9ac0e29329c9d802380e4b.patch";
      hash = "sha256-8PlrBcIumlxFjNXCAfm4NpSIxAnvLR8TopHzneJyzf0=";
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
    inherit version src;
    format = "pyproject";

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_c
    '';

    nativeBuildInputs = [
      cython_3
      postgresql
      setuptools
      tomli
    ];

    # tested in psycopg
    doCheck = false;

    meta = baseMeta // {
      description = "C optimisation distribution for Psycopg";
    };
  };

  psycopg-pool = buildPythonPackage {
    pname = "${pname}-pool";
    inherit version src;
    format = "setuptools";

    # apply patches to base repo
    inherit patches;

    # move into source root after patching
    postPatch = ''
      cd psycopg_pool
    '';

    propagatedBuildInputs = [
      typing-extensions
    ];

    # tested in psycopg
    doCheck = false;

    meta = baseMeta // {
      description = "Connection Pool for Psycopg";
    };
  };

in

buildPythonPackage rec {
  inherit pname version src;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  outputs = [
    "out"
    "doc"
  ];

  sphinxRoot = "../docs";

  # Introduce this file necessary for the docs build via environment var
  LIBPQ_DOCS_FILE = fetchurl {
    url = "https://raw.githubusercontent.com/postgres/postgres/REL_14_STABLE/doc/src/sgml/libpq.sgml";
    hash = "sha256-yn09fR9+7zQni8SvTG7BUmYRD7MK7u2arVAznWz2oAw=";
  };

  inherit patches;

  # only move to sourceRoot after patching, makes patching easier
  postPatch = ''
    cd psycopg
  '';

  nativeBuildInputs = [
    furo
    setuptools
    shapely
    sphinx-autodoc-typehints
    sphinxHook
  ];

  propagatedBuildInputs = [
    psycopg-c
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  pythonImportsCheck = [
    "psycopg"
    "psycopg_c"
    "psycopg_pool"
  ];

  passthru.optional-dependencies = {
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
  ++ lib.optional (stdenv.isLinux) postgresqlTestHook
  ++ passthru.optional-dependencies.c
  ++ passthru.optional-dependencies.pool;

  env = {
    postgresqlEnableTCP = 1;
    PGUSER = "psycopg";
    PGDATABASE = "psycopg";
  };

  preCheck = ''
    cd ..
  '' + lib.optionalString (stdenv.isLinux) ''
    export PSYCOPG_TEST_DSN="host=/build/run/postgresql user=$PGUSER"
  '';

  disabledTests = [
    # don't depend on mypy for tests
    "test_version"
    "test_package_version"
  ];

  disabledTestPaths = [
    # Network access
    "tests/test_dns.py"
    "tests/test_dns_srv.py"
    # Mypy typing test
    "tests/test_typing.py"
    "tests/crdb/test_typing.py"
  ];

  pytestFlagsArray = [
    "-o" "cache_dir=$TMPDIR"
    "-m" "'not refcount and not timing'"
  ];

  postCheck = ''
    cd ${pname}
  '';

  passthru = {
    c = psycopg-c;
    pool = psycopg-pool;
  };

  meta = baseMeta // {
    description = "PostgreSQL database adapter for Python";
  };
}
