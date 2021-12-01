{ lib
, buildPythonPackage
, fetchPypi
, nose
, python-dateutil
, ipython_genutils
, decorator
, pyzmq
, ipython
, jupyter-client
, ipykernel
, tornado
, isPy3k
, futures ? null
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "6.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0a97b276c62db633e9e97a816282bdd166f9df74e28204f0c8fa54b71944cfdc";
  };

  buildInputs = [ nose ];

  propagatedBuildInputs = [ python-dateutil ipython_genutils decorator pyzmq ipython jupyter-client ipykernel tornado
  ] ++ lib.optionals (!isPy3k) [ futures ];

  # Requires access to cluster
  doCheck = false;

  disabled = !isPy3k;

  meta = {
    description = "Interactive Parallel Computing with IPython";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
