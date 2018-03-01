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
  version = "5.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83d5e23132f0d8f79ccd3939f53fb9fa97f88a896a85114dc48d0e86909b06c4";
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