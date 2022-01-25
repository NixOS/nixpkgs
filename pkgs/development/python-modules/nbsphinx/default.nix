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
  version = "0.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b5090c824b330b36c2715065a1a179ad36526bff208485a9865453d1ddfc34ec";
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
