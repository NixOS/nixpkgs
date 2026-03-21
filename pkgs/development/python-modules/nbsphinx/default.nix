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
}:

buildPythonPackage rec {
  pname = "nbsphinx";
  version = "0.9.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0HZZCDmajuK1e+euiBzy6ljWbbOve78z5utI+DvqVJU=";
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

  env.JUPYTER_PATH = "${nbconvert}/share/jupyter";

  pythonImportsCheck = [ "nbsphinx" ];

  meta = {
    description = "Jupyter Notebook Tools for Sphinx";
    homepage = "https://nbsphinx.readthedocs.io/";
    changelog = "https://github.com/spatialaudio/nbsphinx/blob/${version}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
