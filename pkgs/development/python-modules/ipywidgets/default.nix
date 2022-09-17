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
  version = "7.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xy+ht6+uGvMsiAiMmCitl43pPd2jk9ftQU5VP+6T3Ks=";
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
