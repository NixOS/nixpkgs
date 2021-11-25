{ lib, fetchPypi, buildPythonPackage
, cloudpickle, numpy, future, networkx
, six, tqdm, scipy, pymongo
}:

buildPythonPackage rec {
  pname = "hyperopt";
  version = "0.2.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bf89ae58050bbd32c7307199046117feee245c2fd9ab6255c7308522b7ca149";
  };

  propagatedBuildInputs = [ future cloudpickle numpy networkx six tqdm scipy pymongo ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "hyperopt" ];

  meta = with lib; {
    description = "Distributed Asynchronous Hyperparameter Optimization";
    homepage    = "http://hyperopt.github.com/hyperopt/";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
