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
  pname = "jupyter-client";
  version = "7.0.2";

  src = fetchPypi {
    pname = "jupyter_client";
    inherit version;
    sha256 = "0c6cabd07e003a2e9692394bf1ae794188ad17d2e250ed747232d7a473aa772c";
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
