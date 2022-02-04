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
  version = "7.6.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00974f7cb4d5f8d494c19810fedb9fa9b64bffd3cda7c2be23c133a1ad3c99c5";
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
