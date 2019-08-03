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
  version = "5.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98e8af5edff5d24e4d31e73bc21043130ae9d955a91aa93fc0bc3b1d0f7b5880";
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
    homepage = https://jupyter.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}