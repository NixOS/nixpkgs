{ lib
, buildPythonPackage
, fetchPypi
, entrypoints
, jupyter_core
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
  version = "7.4.8";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-EJo8M7YqnPZaqDJYUKCZmnlfrBVdneT3VVrvXzEO41o=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
