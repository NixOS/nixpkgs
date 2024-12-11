{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  docutils,
  jinja2,
  nbconvert,
  nbformat,
  sphinx,
  traitlets,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.9.5";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-c2kW57Daso/JBPSprjtTqaUMKfzMYynAUvzHSFq88rc=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonImportsCheck = [ "nbsphinx" ];

  meta = with lib; {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    changelog = "https://github.com/spatialaudio/nbsphinx/blob/${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ ];
  };
}
