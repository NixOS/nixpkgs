{ lib
, buildPythonPackage
, fetchPypi
, traitlets
, jupyter_core
, pyzmq
, dateutil
, isPyPy
, py
, tornado
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "6.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b360f8d4638bc577a4656e93f86298db755f915098dc763f6fc05da0c5d7a595";
  };

  propagatedBuildInputs = [
    traitlets
    jupyter_core
    pyzmq
    dateutil
    tornado
  ] ++ lib.optional isPyPy py;

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = "https://jupyter.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
