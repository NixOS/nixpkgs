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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "369c16fe93af14c878d61fb3e81d838196fb35b27deade2cd7b95efe1fe56ea0";
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
