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
, packaging
, psutil
, tornado
, tqdm
, isPy3k
, futures ? null
}:

buildPythonPackage rec {
  pname = "ipyparallel";
  version = "8.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D9n2SlEgmAqJtkKZgGwSu434zuoVXlIAtwUwHrJAHhk=";
  };

  buildInputs = [ nose ];

  propagatedBuildInputs = [ python-dateutil ipython_genutils decorator pyzmq ipython jupyter-client ipykernel packaging psutil tornado tqdm
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
