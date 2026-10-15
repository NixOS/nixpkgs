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
  version = "0.2.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G/ia5YBQu9MscwcZkEYRf+7iRcL9mrYlXHMIUit8oUk=";
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
