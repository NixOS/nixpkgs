{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyter-core,
  hatchling,
  python-dateutil,
  pyzmq,
  tornado,
  traitlets,
  pythonOlder,
  importlib-metadata,
}:

buildPythonPackage rec {
  pname = "jupyter-client";
  version = "8.6.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_client";
    inherit version;
    hash = "sha256-K9oU1V7lulhVKoxTrkPSFa2YaIU0iSE/N9oGDO1U2N8=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jupyter-core
    python-dateutil
    pyzmq
    tornado
    traitlets
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  pythonImportsCheck = [ "jupyter_client" ];

  # Circular dependency with ipykernel
  doCheck = false;

  meta = {
    description = "Jupyter protocol implementation and client libraries";
    homepage = "https://github.com/jupyter/jupyter_client";
    changelog = "https://github.com/jupyter/jupyter_client/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
  };
}
