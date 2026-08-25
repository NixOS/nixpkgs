{
  lib,
  buildPythonPackage,
  cloudpickle,
  fetchPypi,
  hatch-vcs,
  hatchling,
  lightgbm,
  networkx,
  numpy,
  py4j,
  pymongo,
  pyspark,
  scikit-learn,
  scipy,
  tqdm,
}:

buildPythonPackage (finalAttrs: {
  pname = "hyperopt";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-15p3Ui/v7BOiWLl6DMvfQIMrMnDeTbCCeLsHubk065o=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    cloudpickle
    networkx
    numpy
    scipy
    tqdm
  ];

  optional-dependencies = {
    SparkTrials = [
      pyspark
      py4j
    ];
    MongoTrials = [ pymongo ];
    ATPE = [
      lightgbm
      scikit-learn
    ];
  };

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "hyperopt" ];

  meta = {
    description = "Distributed Asynchronous Hyperparameter Optimization";
    homepage = "http://hyperopt.github.io/hyperopt/";
    changelog = "https://github.com/hyperopt/hyperopt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "hyperopt-mongo-worker";
  };
})
