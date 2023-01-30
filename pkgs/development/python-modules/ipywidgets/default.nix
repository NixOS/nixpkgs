{ buildPythonPackage
, fetchPypi
, ipykernel
, ipython
, jupyterlab-widgets
, lib
, nbformat
, pytestCheckHook
, pytz
, traitlets
, widgetsnbextension
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "8.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wABad6R9d4icr+2JK1jjO0oqlnEhVEBMZUjsIicoEeo=";
  };

  propagatedBuildInputs = [
    ipython
    ipykernel
    jupyterlab-widgets
    traitlets
    nbformat
    pytz
    widgetsnbextension
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
