{ lib
, buildPythonPackage
, fetchPypi
, nose
, dateutil
, ipython_genutils
, decorator
, pyzmq
, ipython
, jupyter_client
, ipykernel
, tornado
, isPy3k
, futures
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "6.1.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f1e03ebb8d17f67f03bafa5d85f220883462f7bd7a97fe904c7d56ffba8534a3";
  };

  buildInputs = [ nose ];

  propagatedBuildInputs = [ dateutil ipython_genutils decorator pyzmq ipython jupyter_client ipykernel tornado
  ] ++ lib.optionals (!isPy3k) [ futures ];

  # Requires access to cluster
  doCheck = false;

  meta = {
    description = "Interactive Parallel Computing with IPython";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}