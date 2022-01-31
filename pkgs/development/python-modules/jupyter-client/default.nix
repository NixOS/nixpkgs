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
  version = "7.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a5f995a73cffb314ed262713ae6dfce53c6b8216cea9f332071b8ff44a6e1654";
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
