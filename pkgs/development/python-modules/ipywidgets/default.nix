{ buildPythonPackage
, fetchPypi
, ipykernel
, ipython_genutils
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
    ipykernel
    ipython_genutils
    jupyterlab-widgets
    traitlets
    nbformat
    widgetsnbextension
  ];

  checkInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "IPython HTML widgets for Jupyter";
    homepage = "https://ipython.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fridh ];
  };
}
