{
  stdenv,
  lib,
  buildPythonPackage,
  pythonOlder,
  isPyPy,
  fetchPypi,
  libpq,
  postgresql,
  postgresqlTestHook,
  openssl,
  sphinxHook,
  sphinx-better-theme,
  buildPackages,
}:

buildPythonPackage rec {
  pname = "psycopg2";
  version = "2.9.10";
  format = "setuptools";

  # Extension modules don't work well with PyPy. Use psycopg2cffi instead.
  # c.f. https://github.com/NixOS/nixpkgs/pull/104151#issuecomment-729750892
  disabled = pythonOlder "3.6" || isPyPy;

  outputs = [
    "out"
    "doc"
  ];

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EuwLQLAnP5UpYjPodQRBM5KY5qVy9wOdpbJg48i2DhE=";
  };

  postPatch = ''
    # Preferably upstream would not depend on pg_config because config scripts are incompatible with cross-compilation, however postgresql's pc file is lacking information.
    # some linker flags are added but the linker ignores them because they're incompatible
    # https://github.com/psycopg/psycopg2/blob/89005ac5b849c6428c05660b23c5a266c96e677d/setup.py
    substituteInPlace setup.py \
      --replace-fail "self.pg_config_exe = self.build_ext.pg_config" 'self.pg_config_exe = "${libpq.pg_config}/bin/pg_config"'
  '';

  nativeBuildInputs = [
    sphinxHook
    sphinx-better-theme
  ];

  buildInputs = [ libpq ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ openssl ];

  sphinxRoot = "doc/src";

  # test suite breaks at some point with:
  #   current transaction is aborted, commands ignored until end of transaction block
  doCheck = false;

  nativeCheckInputs = [
    postgresql
    postgresqlTestHook
  ];

  env = {
    PGDATABASE = "psycopg2_test";
  };

  pythonImportsCheck = [ "psycopg2" ];

  disallowedReferences = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.libpq
  ];

  meta = with lib; {
    description = "PostgreSQL database adapter for the Python programming language";
    homepage = "https://www.psycopg.org";
    license = with licenses; [
      lgpl3Plus
      zpl20
    ];
    maintainers = [ ];
  };
}
