{ lib
, buildPythonPackage
, fetchPypi
, traitlets
, jupyter_core
, pyzmq
, dateutil
, isPyPy
, py
, ipykernel
, ipython
, mock
, pytest
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "5.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "462790d46b244f0a631ea5e3cd5cdbad6874d5d24cc0ff512deb7c16cdf8653d";
  };

  checkInputs = [ ipykernel ipython mock pytest ];
  propagatedBuildInputs = [traitlets jupyter_core pyzmq dateutil] ++ lib.optional isPyPy py;

  checkPhase = ''
    py.test
  '';

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = http://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}