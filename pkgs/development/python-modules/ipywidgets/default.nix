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
  version = "8.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3n13nyBF1g3p9sJfZT/a4tuleJjmoShElLO6ILaJO7g=";
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
