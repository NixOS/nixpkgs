{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  mirakuru,
  packaging,
  port-for,
  psycopg,
  pytest,
  postgresql,
}:

buildPythonPackage rec {
  pname = "pytest-postgresql";
  version = "7.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dbfixtures";
    repo = "pytest-postgresql";
    tag = "v${version}";
    hash = "sha256-/EekUveW3wb8NlcKacMJpjjU7bpFvnNMpAuZ9h0sbpw=";
  };

  postPatch = ''
    sed -i 's#/usr/lib/postgresql/.*/bin/pg_ctl#${postgresql}/bin/pg_ctl#' pytest_postgresql/plugin.py
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    mirakuru
    port-for
    psycopg
    packaging
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
    # "ValueError: Pytest terminal summary report not found"
    "test_postgres_drop_test_database"
    "test_postgres_loader_in_cli"
    "test_postgres_loader_in_ini"
    "test_postgres_options_config_in_cli"
    "test_postgres_options_config_in_ini"
    "test_postgres_port_search_count_in_cli_is_int"
    "test_postgres_port_search_count_in_ini_is_int"
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
    changelog = "https://github.com/dbfixtures/pytest-postgresql/blob/v${version}/CHANGES.rst";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
