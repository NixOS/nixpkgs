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
  version = "0.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0kh0d83xavpffdp4xp4hq8xy43l6lyv3d1a25rnc15jcbdf1nghw";
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
