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
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0j56bxdj08vn3q1804qwb1ywhga1mdg1awgm7i64wfpfwi8df2zm";
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
