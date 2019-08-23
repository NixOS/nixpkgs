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
  version = "6.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rf0dbpxf5z82bw8lsjj45r3wdd4wc74anz4wiiaf2rbjqlb1ivn";
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