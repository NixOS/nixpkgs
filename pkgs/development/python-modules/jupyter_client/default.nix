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
, tornado
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "5.2.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5f9cb06105c1d2d30719db5ffb3ea67da60919fb68deaefa583deccd8813551";
  };

  checkInputs = [ ipykernel ipython mock pytest ];
  propagatedBuildInputs = [traitlets jupyter_core pyzmq dateutil tornado ] ++ lib.optional isPyPy py;

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