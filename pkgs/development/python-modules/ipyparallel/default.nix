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
  version = "6.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02b225966d5c20f12b1fba0b6b10aa5d352a6b492e075f137ff0ff6e95b9358e";
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