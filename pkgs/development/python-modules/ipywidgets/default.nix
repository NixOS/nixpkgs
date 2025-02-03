{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  comm,
  ipykernel,
  ipython,
  jsonschema,
  jupyterlab-widgets,
  lib,
  pytest7CheckHook,
  pytz,
  traitlets,
  widgetsnbextension,
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "8.1.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9fnuquCCsYI86erCV1JylS9A10iJOXKVbcCXAKY5LZw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    comm
    ipython
    jupyterlab-widgets
    traitlets
    widgetsnbextension
  ];

  nativeCheckInputs = [
    ipykernel
    jsonschema
    pytest7CheckHook
    pytz
  ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    license = lib.licenses.bsd3;
  };
}
