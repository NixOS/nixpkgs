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
  version = "6.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9afb0001d6fa2eca9340e9daab5da021db05211987868f47ab5b305d701cb12d";
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