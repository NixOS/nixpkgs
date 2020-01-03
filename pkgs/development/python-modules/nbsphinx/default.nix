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
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03g0mqbgk143cq3l3r42js2iy5l6iyvpckpqip4p468rlzrddyhn";
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
