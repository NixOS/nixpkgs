{
  lib,
  buildPythonPackage,
  fetchpatch,
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
  version = "0.9.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q9KYpobVX6iU72l8UdRPJOU6oxLa2uOOgpIPJQpUVv4=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/spatialaudio/nbsphinx/commit/a921973a5d8ecc39c6e02184572b79ab72c9978c.patch";
      hash = "sha256-uxfSaOESWn8uVcUm+1ADzQgMQDEqaTs0TbfNYsS+E6I=";
    })
  ];

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
