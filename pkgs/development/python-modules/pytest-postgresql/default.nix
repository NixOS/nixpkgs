{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytest,
  port-for,
  mirakuru,
  pytestCheckHook,
  pytest-cov,
  pytest-xdist,
  psycopg,
  postgresql,
  glibcLocales,
}:
buildPythonPackage rec {
  pname = "pytest-postgresql";
  version = "4.1.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ClearcodeHQ";
    repo = "pytest-postgresql";
    rev = "v${version}";
    hash = "sha256-ckwab7q5moPJRpx8+C7cx6exBneYwfk5XTbj3vgMhPE=";
  };

  propagatedBuildInputs = [
    setuptools
    pytest
    port-for
    mirakuru
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-xdist
    psycopg
    postgresql
    glibcLocales
  ];

  pytestFlagsArray = [
    "--postgresql-exec=${postgresql}/bin/pg_ctl"
    "--ignore=tests/docker/test_nooproc_docker.py"
    "--ignore=tests/test_template_database.py"
  ];

  pythonImportsCheck = [
    "pytest_postgresql"
    "pytest_postgresql.factories"
  ];

  meta = with lib; {
    description = "PostgreSQL fixtures and fixture factories for pytest";
    homepage = https://github.com/ClearcodeHQ/pytest-postgresql;
    license = licenses.lgpl3Only;
    maintainers = [maintainers.apeschar];
    platforms = platforms.all;
  };
}
