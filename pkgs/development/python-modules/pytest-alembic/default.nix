{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  alembic,
  pytest,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "pytest-alembic";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "schireson";
    repo = "pytest-alembic";
    rev = "v${version}";
    hash = "sha256-A+Nl+DAK8uhC3iOgS1i6x/nj9BJ0My3lpft+pRdoab8=";
  };
  pyproject = true;
  build-system = [ poetry-core ];
  dependencies = [
    alembic
    pytest
    sqlalchemy
  ];

  meta = {
    description = "Pytest plugin to test alembic migrations (with default tests) and which enables you to write tests specific to your migrations";
    homepage = "https://github.com/schireson/pytest-alembic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rcoeurjoly ];
  };
}
