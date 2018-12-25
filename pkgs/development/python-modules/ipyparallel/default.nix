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
  version = "6.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k9701r120gv0an0wxvcjrbmhns8lq3zj6px5y2izly56j2dafqy";
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