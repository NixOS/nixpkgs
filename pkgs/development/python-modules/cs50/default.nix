{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mysqlclient,
  psycopg2-binary,
  pgloader,
  pkg-config,
  postgresql,
  setuptools,
  flask,
  sqlalchemy,
  sqlparse,
  termcolor
}:
buildPythonPackage rec {
  pname = "cs50";
  version = "9.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cs50";
    repo = "python-cs50";
    tag = "v${version}";
    hash = "sha256-g7ws5ikzLt2ciS0QTPTJDRAqePyYPDCYIpJuwnWHJNQ=";
  };

  build-system = [setuptools];

  dependencies = [
    mysqlclient
    psycopg2-binary
    pgloader
    pkg-config
    postgresql
    flask
    sqlalchemy
    sqlparse
    termcolor
  ];

  meta = {
    description = "This is CS50's library for Python.";
    homepage = "https://github.com/cs50/python-cs50";
    changelog = "https://github.com/cs50/python-cs50/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [jakobgetz];
  };
}
