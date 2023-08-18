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
, pythonOlder
, py
}:

buildPythonPackage rec {
  pname = "jupyter-client";
  version = "8.3.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyter_client";
    inherit version;
    hash = "sha256-OvaZIf6ZYXvhZwOZoLhXrWcnXu/PopHiyBoWC3tlD18=";
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

  meta = with lib; {
    description = "Jupyter protocol implementation and client libraries";
    homepage = "https://jupyter-client.readthedocs.io";
    changelog = "https://github.com/jupyter/jupyter_client/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
