{ lib
, buildPythonPackage
, fetchPypi
, docutils
, jinja2
, nbconvert
, nbformat
, sphinx
, traitlets
, pythonOlder
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.8.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q+GMBLM9m837PWbxGV9rDVHuykY+ywf2Bh3kl+QzFuQ=";
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

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    changelog = "https://github.com/spatialaudio/nbsphinx/blob/${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
