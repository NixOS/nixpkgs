{
  lib,
  setuptools,
  alembic,
  banal,
  buildPythonPackage,
  fetchFromGitHub,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "1.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pudo";
    repo = "dataset";
    tag = version;
    hash = "sha256-hu1Qa5r3eT+xHFrCuYyJ9ZWvyoJBsisO34zvkch65Tc=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    alembic
    banal
    sqlalchemy
  ];

  # checks attempt to import nonexistent module 'test.test' and fail
  doCheck = false;

  pythonImportsCheck = [ "dataset" ];

  meta = {
    description = "Toolkit for Python-based database access";
    homepage = "https://dataset.readthedocs.io";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xfnw ];
    # SQLAlchemy >= 2.0.0 is unsupported
    # https://github.com/pudo/dataset/issues/411
    broken = lib.versionAtLeast sqlalchemy.version "2.0.0";
  };
}
