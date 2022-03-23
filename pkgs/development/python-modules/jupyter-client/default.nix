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
  version = "7.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-TqYQM3Jsjlee21VibY7i5r8KgxWN3zdRuN1GssXNHpY=";
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
