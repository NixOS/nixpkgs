{
  buildPythonPackage,
  fetchPypi,
  setuptools,
  comm,
  ipykernel,
  ipython,
  jsonschema,
  jupyterlab-widgets,
  lib,
  pytestCheckHook,
  pytz,
  traitlets,
  widgetsnbextension,
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "8.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FfGsBQucy+/UXcz7su9r7QAp2CeGgtVp1xuN2WvuA3Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    comm
    ipython
    jupyterlab-widgets
    traitlets
    widgetsnbextension
  ];

  nativeCheckInputs = [
    ipykernel
    jsonschema
    pytestCheckHook
    pytz
  ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    license = lib.licenses.bsd3;
  };
}
