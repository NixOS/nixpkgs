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
      sha256 = "sha256-omLdOs/ybOcqJSiDofS1744r1eupuxVjpaoTDa2OpEU=";
    })
    # Support alembic 1.18
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/1a420b8ded794a81595cf18cb03240b69ef9602d.patch";
      sha256 = "sha256-unAA+LiI8HvH6ljugbpHgb5veKJxPHKsPcaTUs36uAc=";
    })
    # Support python 3.13
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/435f98304b077970f7a80944c6a7489e72a25eec.patch";
      sha256 = "sha256-u6fFIesNSSstvwYOkvPjk/QMoenctfBA8aPII99yrqw=";
    })
    # Support python 3.14
    (fetchpatch {
      url = "https://github.com/xzkostyan/clickhouse-sqlalchemy/commit/353703c860d2f871a32df34f5f71d7c2af758c0c.patch";
      sha256 = "sha256-aHWX66dHlaYrfVVLsUnmm9efEKdBX3dJG+0EEk9lv0w=";
      excludes = [ ".github/workflows/*" ];
    })
  ];

  postPatch = ''
    # The asynch driver rewrites `%(name)s` binds into `{name}` only for the
    # broken brace-style parameter substitution that asynch shipped in exactly
    # 0.3.1 (asynch#141). asynch#147 restored this change, which
    # is what 0.4.x uses, so applying the rewrite to >= 0.4.0 is broken.
    # Restrict the rewrite to 0.3.1.
    substituteInPlace clickhouse_sqlalchemy/drivers/asynch/base.py \
      --replace-fail ") >= (0, 3, 1)" ") == (0, 3, 1)"

    # Fix JSON type handling in the base driver
    substituteInPlace clickhouse_sqlalchemy/drivers/base.py \
      --replace-fail "'Object(\'json\')': types.JSON" "'JSON': types.JSON"
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

  passthru.updateScript = nix-update-script { };

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
