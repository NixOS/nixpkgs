{
  lib,
  setuptools,
  alembic,
  banal,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  sqlalchemy_1_4,
}:

buildPythonPackage rec {
  pname = "dataset";
  version = "1.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

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
    (alembic.override { sqlalchemy = sqlalchemy_1_4; })
    banal
    # SQLAlchemy >= 2.0.0 is unsupported
    # https://github.com/pudo/dataset/issues/411
    sqlalchemy_1_4
  ];

  # checks attempt to import nonexistent module 'test.test' and fail
  doCheck = false;

  pythonImportsCheck = [ "dataset" ];

  meta = with lib; {
    description = "Toolkit for Python-based database access";
    homepage = "https://dataset.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ xfnw ];
  };
}
