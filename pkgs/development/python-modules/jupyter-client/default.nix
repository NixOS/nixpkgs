{ lib
, buildPythonPackage
, fetchPypi
, entrypoints
, jupyter_core
, nest-asyncio
, python-dateutil
, pyzmq
, tornado
, traitlets
, isPyPy
, py
}:

buildPythonPackage rec {
  pname = "jupyter_client";
  version = "7.0.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b6e06000eb9399775e0a55c52df6c1be4766666209c22f90c2691ded0e338dc";
  };

  propagatedBuildInputs = [
    entrypoints
    jupyter_core
    nest-asyncio
    python-dateutil
    pyzmq
    tornado
    traitlets
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
