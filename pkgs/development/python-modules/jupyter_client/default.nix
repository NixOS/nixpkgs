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
  version = "6.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "649ca3aca1e28f27d73ef15868a7c7f10d6e70f761514582accec3ca6bb13085";
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
