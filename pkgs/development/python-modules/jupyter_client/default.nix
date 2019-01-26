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
  version = "5.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "27befcf0446b01e29853014d6a902dd101ad7d7f94e2252b1adca17c3466b761";
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