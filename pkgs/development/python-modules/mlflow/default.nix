{
  lib,
  buildPythonPackage,
  fetchPypi,

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
  format = "wheel";
  __structuredAttrs = true;

  # We build from the PyPI wheel rather than fetchFromGitHub, because the mlflow-server
  # JS UI is absent from GitHub but provided in the wheel.
  src = fetchPypi {
    pname = "mlflow";
    inherit (finalAttrs) version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-4cKO1MSFV8xSx2bxfxylgmdT3fJB1D8w+ZxF9+prPOA=";
  };

  # Nix-wrapped python populates sys.path via NIX_PYTHONPATH/site hooks,
  # but PYTHONPATH stays unset in os.environ. mlflow spawns the server
  # in a subprocess with a curated env, so without this patch the child
  # interpreter cannot import uvicorn / mlflow itself.
  postInstall = ''
    patch -p1 -d "$out/lib/python"*/site-packages < ${./subprocess-pythonpath.patch}
  '';

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
    changelog = "https://github.com/mlflow/mlflow/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    # Build from wheel which contains pure Python and pre-built JS bundle.
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
    ];
    maintainers = with lib.maintainers; [
      GaetanLepage
    ];
  };
})
