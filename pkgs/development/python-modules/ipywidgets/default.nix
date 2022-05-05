{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
, pytest
, mock
, ipython
, ipykernel
, jupyterlab-widgets
, traitlets
, notebook
, widgetsnbextension
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "7.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q0pVloVaiLg3YZIcdocH1l5YRwaBObwXKd3+g0cDVCo=";
  };

  # Tests are not distributed
  # doCheck = false;

  buildInputs = [ nose pytest mock ];
  propagatedBuildInputs = [
    ipython
    ipykernel
    jupyterlab-widgets
    traitlets
    notebook
    widgetsnbextension
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = "http://ipython.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
