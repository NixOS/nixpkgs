{ lib
, buildPythonPackage
, fetchPypi
, python
, nose
, pytest
, mock
, ipython
, ipykernel
, traitlets
, notebook
, widgetsnbextension
}:

buildPythonPackage rec {
  pname = "ipywidgets";
  version = "7.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a3e224f430163f767047ab9a042fc55adbcab0c24bbe6cf9f306c4f89fdf0ba3";
  };

  # Tests are not distributed
  # doCheck = false;

  buildInputs = [ nose pytest mock ];
  propagatedBuildInputs = [
    ipython
    ipykernel
    traitlets
    notebook
    widgetsnbextension
  ];

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    description = "IPython HTML widgets for Jupyter";
    homepage = http://ipython.org/;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}