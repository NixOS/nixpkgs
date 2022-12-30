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
  version = "0.8.11";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-q+GMBLM9m837PWbxGV9rDVHuykY+ywf2Bh3kl+QzFuQ=";
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
