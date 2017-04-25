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
  version = "6.0.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "afa6248850cff14ef86117db87aeab0b12237e4eaf740e73716460ed593a43a7";
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