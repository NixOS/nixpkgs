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
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "7.7.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q0pVloVaiLg3YZIcdocH1l5YRwaBObwXKd3+g0cDVCo=";
  };

  propagatedBuildInputs = [
    ipython
    ipykernel
    jupyterlab-widgets
    traitlets
    nbformat
    widgetsnbextension
  ];

  checkInputs = [ pytestCheckHook ];

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
