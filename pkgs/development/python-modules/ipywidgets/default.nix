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
  version = "7.0.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f98b4c3719097c9d2e6489f303db520b20bd4de3e0b1d6d4f92f81bfe3c2a0c8";
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