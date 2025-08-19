{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  mirakuru,
  port-for,
  psycopg,
  pytest,
  postgresql,
}:

buildPythonPackage rec {
  pname = "pytest-postgresql";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "pytest-postgresql";
    tag = "v${version}";
    hash = "sha256-6D9QNcfq518ORQDYCH5G+LLJ7tVWPFwB6ylZR3LOZ5g=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace-fail "--max-worker-restart=0" ""
    sed -i 's#/usr/lib/postgresql/.*/bin/pg_ctl#${postgresql}/bin/pg_ctl#' pytest_postgresql/plugin.py
  '';

  buildInputs = [ pytest ];

  dependencies = [
    mirakuru
    port-for
    psycopg
    setuptools # requires 'pkg_resources' at runtime
  ];

  nativeCheckInputs = [
    postgresql
    pytestCheckHook
    pytest-cov-stub
  ];
  pytestFlags = [
    "-pno:postgresql"
  ];
  disabledTestPaths = [ "tests/docker/test_noproc_docker.py" ]; # requires Docker
  disabledTests = [
    # permissions issue running pg as Nixbld user
    "test_executor_init_with_password"
    # "ValueError: Pytest terminal summary report not found"
    "test_postgres_loader_in_cli"
    "test_postgres_options_config_in_cli"
    "test_postgres_options_config_in_ini"
  ];
  pythonImportsCheck = [
    "pytest_postgresql"
    "pytest_postgresql.executor"
  ];

  # Can't reliably run checkPhase on darwin because of nix bug, see:
  #  https://github.com/NixOS/nixpkgs/issues/371242
  doCheck = !stdenv.buildPlatform.isDarwin;

  meta = {
    homepage = "https://pypi.python.org/pypi/pytest-postgresql";
    description = "Pytest plugin that enables you to test code on a temporary PostgreSQL database";
    changelog = "https://github.com/ClearcodeHQ/pytest-postgresql/blob/v${version}/CHANGES.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
