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
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "097dee333558f400e9abbb53ce7d4fa64a257cfa89dd20f7554dca7f0cd5e143";
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
