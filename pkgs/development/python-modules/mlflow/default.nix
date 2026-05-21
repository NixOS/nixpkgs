{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,
  alembic,
  cryptography,
  docker,
  flask,
  flask-cors,
  graphene,
  gunicorn,
  huey,
  matplotlib,
  mlflow-skinny,
  mlflow-tracing,
  numpy,
  pandas,
  pyarrow,
  scikit-learn,
  scipy,
  skops,
  sqlalchemy,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlflow";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OxhM+KCem0sb9cwtyzrUD/MGfoiiCfgU47qipYRDaFk=";
  };

  # ppyproject.release.toml is the one shipped in the Pypi package, so we use it too.
  postPatch = ''
    mv pyproject.release.toml pyproject.toml
  '';

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "cryptography"
  ];
  dependencies = [
    aiohttp
    alembic
    cryptography
    docker
    flask
    flask-cors
    graphene
    gunicorn
    huey
    matplotlib
    mlflow-skinny
    mlflow-tracing
    numpy
    pandas
    pyarrow
    scikit-learn
    scipy
    skops
    sqlalchemy
  ];

  pythonImportsCheck = [ "mlflow" ];

  # I (@GaetanLepage) gave up at enabling tests:
  # - They require a lot of dependencies (some unpackaged);
  # - Many errors occur at collection time;
  # - Most (all ?) tests require internet access anyway.
  doCheck = false;

  meta = {
    description = "Open source platform for the machine learning lifecycle";
    mainProgram = "mlflow";
    homepage = "https://github.com/mlflow/mlflow";
    changelog = "https://github.com/mlflow/mlflow/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
})
