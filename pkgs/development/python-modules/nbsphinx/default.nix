{ lib
, buildPythonPackage
, fetchPypi
, docutils
, jinja2
, nbconvert
, nbformat
, sphinx
, traitlets
, isPy3k
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.8.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "53352237e2363079f6e38637a8ce90b47e720c8e2eb133a6a6f66fc13ff494cb";
  };

  propagatedBuildInputs = [
    docutils
    jinja2
    nbconvert
    nbformat
    sphinx
    traitlets
  ];

  # The package has not tests
  doCheck = false;

  JUPYTER_PATH = "${nbconvert}/share/jupyter";
  pythonImportsCheck = [
    "nbsphinx"
  ];

  disabled = !isPy3k;

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
