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
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09j47hmzgvf7rnz7n4n7295pp6qscq9hp50qva70vglzqck9yyjp";
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
