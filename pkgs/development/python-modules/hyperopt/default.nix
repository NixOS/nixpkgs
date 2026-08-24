{
  lib,
  buildPythonPackage,
  cloudpickle,
  fetchPypi,
  future,
  networkx,
  numpy,
  py4j,
  pymongo,
  pyspark,
  scipy,
  six,
  tqdm,
}:

buildPythonPackage rec {
  pname = "hyperopt";
  version = "0.3.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-15p3Ui/v7BOiWLl6DMvfQIMrMnDeTbCCeLsHubk065o=";
  };

  propagatedBuildInputs = [
    cloudpickle
    future
    networkx
    numpy
    py4j
    pymongo
    pyspark
    scipy
    six
    tqdm
  ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "hyperopt" ];

  meta = {
    description = "Distributed Asynchronous Hyperparameter Optimization";
    mainProgram = "hyperopt-mongo-worker";
    homepage = "http://hyperopt.github.io/hyperopt/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
