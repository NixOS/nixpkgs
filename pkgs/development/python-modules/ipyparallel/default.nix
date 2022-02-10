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
  version = "8.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "63f7e136e88f890e9802522fa5475dd81e7614ba06a8cfe4f80cc3056fdb7d73";
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
