{ lib
, buildPythonPackage
, fetchPypi
, traitlets
, jupyter_core
, pyzmq
, python-dateutil
, isPyPy
, py
, tornado
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "6.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2ab61d79fbf8b56734a4c2499f19830fbd7f6fefb3e87868ef0545cb3c17eb9";
  };

  propagatedBuildInputs = [
    traitlets
    jupyter_core
    pyzmq
    python-dateutil
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
