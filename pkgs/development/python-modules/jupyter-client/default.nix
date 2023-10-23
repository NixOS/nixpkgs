{ lib
, buildPythonPackage
, fetchPypi
, entrypoints
, jupyter-core
, hatchling
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
  version = "8.3.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YClLLVuGk1bIk/V7God+plENYNRc9LOAV/FnLYVpmsk=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    entrypoints
    jupyter-core
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
