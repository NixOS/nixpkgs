{ lib, fetchPypi, buildPythonPackage
, cloudpickle, numpy, future, networkx
, six, tqdm, scipy, pymongo
}:

buildPythonPackage rec {
  pname = "hyperopt";
  version = "0.2.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bc6047d50f956ae64eebcb34b1fd40f186a93e214957f20e87af2f10195295cc";
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
