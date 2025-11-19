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
    sha256 = "1bf89ae58050bbd32c7307199046117feee245c2fd9ab6255c7308522b7ca149";
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

  meta = with lib; {
    description = "Distributed Asynchronous Hyperparameter Optimization";
    mainProgram = "hyperopt-mongo-worker";
    homepage = "http://hyperopt.github.io/hyperopt/";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ ];
  };
}
