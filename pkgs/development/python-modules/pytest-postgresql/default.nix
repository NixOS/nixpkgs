{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, setuptools
, mirakuru
, port-for
, psycopg
, pytest
, postgresql
}:

buildPythonPackage rec {
  pname = "pytest-postgresql";
  version = "5.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "pytest-postgresql";
    rev = "refs/tags/v${version}";
    hash = "sha256-uWKp9yxTdlswoDPMlhx+2mF1cdhFzhGYKGHdXPGlz+w=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace "--cov" ""  \
      --replace "--max-worker-restart=0" ""
    sed -i 's#/usr/lib/postgresql/.*/bin/pg_ctl#${postgresql}/bin/pg_ctl#' pytest_postgresql/plugin.py
  '';

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    mirakuru
    port-for
    psycopg
    setuptools  # requires 'pkg_resources' at runtime
  ];

  nativeCheckInputs = [
    postgresql
    pytestCheckHook
  ];
  pytestFlagsArray = [
    "-p"
    "no:postgresql"
  ];
  disabledTestPaths = [ "tests/docker/test_noproc_docker.py" ];  # requires Docker
  disabledTests = [
    # permissions issue running pg as Nixbld user
    "test_executor_init_with_password"
    # "ValueError: Pytest terminal summary report not found"
    "test_postgres_options_config_in_cli"
    "test_postgres_options_config_in_ini"
  ];
  pythonImportsCheck = [
    "pytest_postgresql"
    "pytest_postgresql.executor"
  ];


  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/pytest-postgresql";
    description = "Pytest plugin that enables you to test code on a temporary PostgreSQL database";
    changelog = "https://github.com/ClearcodeHQ/pytest-postgresql/blob/v${version}/CHANGES.rst";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
