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
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b794219e465b3aab500b800884ff40fd152bb19d8b6f87580de1f3a07170aef8";
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

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = https://nbsphinx.readthedocs.io/;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
