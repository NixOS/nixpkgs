{ buildPythonPackage
, fetchPypi
, ipykernel
, ipython
, jupyterlab-widgets
, lib
, nbformat
, pytestCheckHook
, traitlets
, widgetsnbextension
, pytz
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "8.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cpXT8K2/6VR5oqMyi/Py4CfyWy4aWUSR4Fo9UZ3S5nM=";
  };

  propagatedBuildInputs = [
    ipython
    ipykernel
    jupyterlab-widgets
    traitlets
    nbformat
    widgetsnbextension
  ];

  checkInputs = [
    pytestCheckHook
    pytz
  ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
