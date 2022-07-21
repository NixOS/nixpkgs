{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, fetchurl
, pythonOlder
, substituteAll

# links (libpq)
, postgresql

# propagates
, backports-zoneinfo
, typing-extensions

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
  version = "3.0.15";
in

buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "psycopg";
    repo = pname;
    rev = version;
    hash = "sha256-1Wtp0wDuS6dxa1+u6DXu9fDLU7OtgsCUdbdcO5nhkxU=";
  };

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

  patches = [
    (substituteAll {
      src = ./libpq.patch;
      libpq = "${postgresql.lib}/lib/libpq.so";
    })

    # Work around docs build issues
    # https://github.com/psycopg/psycopg/issues/337
    (fetchpatch {
      name = "sphinx-5.0-compat.patch";
      url = "https://github.com/psycopg/psycopg/commit/ebff3a8392f002100d1e71d3deb94f27fb8cc0cf.patch";
      hash = "sha256-QP9I6/xVJyWj5MQqWqxtmdBlesNUOwpYSMuzogJSnos=";
    })
    (fetchpatch {
      name = "libpq-sqml-env-var.patch";
      url = "https://github.com/psycopg/psycopg/commit/adf9cbdc1020abf87ae602fe0eb493c294459a93.patch";
      hash = "sha256-HJ2Cx7Vg7PSitDEOqCUF7ehNU8aI+iFT886dk2wHsAI=";
    })
    (fetchpatch {
      name = "avoid-dnspython-import-in-docs.patch";
      url = "https://github.com/psycopg/psycopg/commit/3058421503b3fcbcf06382d558aac7b9ca2eaaec.patch";
      hash = "sha256-D4vj5STafkQ34HWUyKZ3A9w9bY8holifPn3lsBjfVZA=";
    })
  ];

  # only move to sourceRoot after patching, makes patching easier
  postPatch = ''
    cd ${pname}
  '';

  nativeBuildInputs = [
    furo
    shapely
    sphinxHook
    sphinx-autodoc-typehints
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    backports-zoneinfo
  ];

  pythonImportsCheck = [
    "psycopg"
  ];

  passthru.optional-dependencies = {
    # TODO: package remaining variants
    #c = [ psycopg-c ];
    #pool = [ psycopg-pool ];
  };

  preCheck = ''
    cd ..
  '';

  checkInputs = [
    pproxy
    pytest-asyncio
    pytest-randomly
    pytestCheckHook
    postgresql
  ];

  disabledTests = [
    # linters shouldn't be run in checks
    "test_version"
  ];

  disabledTestPaths = [
    # TODO: requires the pooled variant
    "tests/pool/"
    # Network access
    "tests/test_dns.py"
    "tests/test_dns_srv.py"
    # Mypy typing test
    "tests/test_typing.py"
  ];

  pytestFlagsArray = [
    "-o cache_dir=$TMPDIR"
  ];

  postCheck = ''
    cd ${pname}
  '';

  meta = with lib; {
    changelog = "https://github.com/psycopg/psycopg/blob/master/docs/news.rst";
    description = "PostgreSQL database adapter for Python";
    homepage = "https://github.com/psycopg/psycopg";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ hexa ];
  };
}
