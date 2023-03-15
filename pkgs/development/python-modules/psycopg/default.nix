{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
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
, pproxy
, pytest-asyncio
, pytest-randomly
, pytestCheckHook
}:

let
  pname = "psycopg";
  version = "3.1.8";

  src = fetchFromGitHub {
    owner = "psycopg";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VmuotHcLWd+k8/GLv0N2wSZR0sZjY+TmGBQjhpYE3YA=";
  };

  patches = [
    (substituteAll {
      src = ./ctypes.patch;
      libpq = "${postgresql.lib}/lib/libpq${stdenv.hostPlatform.extensions.sharedLibrary}";
      libc = "${stdenv.cc.libc}/lib/libc.so.6";
    })
  ];

  baseMeta = {
    changelog = "https://github.com/psycopg/psycopg/blob/master/docs/news.rst";
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
  ] ++ lib.optionals (pythonOlder "3.11") [
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

  preCheck = ''
    cd ..
  '';

  nativeCheckInputs = [
    pproxy
    pytest-asyncio
    pytest-randomly
    pytestCheckHook
    postgresql
  ]
  ++ passthru.optional-dependencies.c
  ++ passthru.optional-dependencies.pool;

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
    "-m" "'not timing'"
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
