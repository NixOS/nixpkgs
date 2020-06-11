{ lib
, buildPythonPackage
, fetchPypi
, docutils
, jinja2
, nbconvert
, nbformat
, sphinx
, traitlets
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77545508fff12fed427fffbd9eae932712fe3db7cc6729b0af5bbd122d7146cf";
  };

  propagatedBuildInputs = [
    docutils
    jinja2
    nbconvert
    nbformat
    sphinx
    traitlets
  ];

  checkPhase = ''
    ${python.interpreter} -m nbsphinx
  '';

  disabled = !isPy3k;

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
