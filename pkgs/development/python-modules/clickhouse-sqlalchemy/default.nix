{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
  sqlalchemy,
  requests,
  asynch,
  clickhouse-driver,
  nix-update-script,
  nixosTests,
}:

buildPythonPackage (finalAttrs: {
  pname = "clickhouse-sqlalchemy";
  version = "0.3.2-unstable-2025-11-24";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xzkostyan";
    repo = "clickhouse-sqlalchemy";
    rev = "25721c3cd6e094ae1853327ab1de3a5d7144acbd";
    hash = "sha256-QCwxPZa3DUFCpZeyrynhd+xuXCyAmtNPRQtJqBbisqg=";
  };

  patches = [
    # Support asynch 0.2.x and 0.3.1+
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/bd62d6a7ec91b72b78bc1ba8315157d7b989f310.patch";
      sha256 = "sha256-HsSDM4eRb1/4m6iGslUUjcgAlhBBq6wn652oMFSuIDI=";
    })
    # Support alembic 1.18
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/1a420b8ded794a81595cf18cb03240b69ef9602d.patch";
      sha256 = "sha256-UOUcm4Jo0NNrzyKzaIEgsxBZCEbKugW1RKgLuIA46xM=";
    })
    # Skip JSON test when driver reports Unknown type JSON
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/b3312f29e5dbb6f04600d682bd668bba36a90177.patch";
      sha256 = "sha256-jpIhdmh67iE5hVuDxg/+9qoGsN8vx24J/hYv41x7zsI=";
    })
  ];

  # The asynch driver rewrites `%(name)s` binds into `{name}` only for the
  # broken brace-style parameter substitution that asynch shipped in exactly
  # 0.3.1 (asynch#141). asynch#147 restored this change, which
  # is what 0.4.x uses, so applying the rewrite to >= 0.4.0 is broken.
  # Restrict the rewrite to 0.3.1.
  postPatch = ''
    substituteInPlace clickhouse_sqlalchemy/drivers/asynch/base.py \
      --replace-fail ") >= (0, 3, 1)" ") == (0, 3, 1)"
  '';

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
    requests
    clickhouse-driver
    asynch
  ];

  pythonImportsCheck = [
    "clickhouse_sqlalchemy"
  ];

  passthru = {
    tests = {
      inherit (nixosTests) clickhouse-sqlalchemy;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ClickHouse dialect for SQLAlchemy";
    homepage = "https://github.com/xzkostyan/clickhouse-sqlalchemy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jlesquembre
      joaosreis
    ];
  };
})
