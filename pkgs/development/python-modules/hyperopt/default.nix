{ stdenv, fetchPypi, buildPythonPackage
, cloudpickle, numpy, future, networkx
, six, tqdm, scipy, pymongo
}:

buildPythonPackage rec {
  pname = "hyperopt";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34xIpivBYUvcN/XMVwBkqTpLgaFlWWIduazuP2U2tlg=";
  };

  propagatedBuildInputs = [ future cloudpickle numpy networkx six tqdm scipy pymongo ];

  # tries to use /homeless-shelter to mimic container usage, etc
  doCheck = false;

  pythonImportsCheck = [ "hyperopt" ];

  meta = with stdenv.lib; {
    description = "Distributed Asynchronous Hyperparameter Optimization";
    homepage    = "http://hyperopt.github.com/hyperopt/";
    license     = licenses.bsd2;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ freezeboy ];
  };
}
