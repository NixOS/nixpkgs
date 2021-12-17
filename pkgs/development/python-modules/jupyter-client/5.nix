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
  pname = "jupyter-client";
  version = "5.3.5";

  src = fetchPypi {
    pname = "jupyter_client";
    inherit version;
    sha256 = "5efdf4131124d4a0d5789101e74827022585f172d2f4b60cf6fa98e0a7511b25";
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
    maintainers = with lib.maintainers; [  ];
  };
}
