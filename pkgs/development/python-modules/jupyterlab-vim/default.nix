{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  jupyterlab,
}:

buildPythonPackage rec {
  pname = "jupyterlab-vim";
  version = "4.1.4";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_vim";
    inherit version;
    hash = "sha256-q/KJGq+zLwy5StmDIa5+vL4Mq+Uj042A1WnApQuFIlo=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    hatch-nodejs-version
  ];

  dependencies = [ jupyterlab ];
  pythonImportsCheck = [ "jupyterlab_vim" ];

  # has no tests
  doCheck = false;

  meta = {
    description = "Vim notebook cell bindings for JupyterLab";
    homepage = "https://github.com/jupyterlab-contrib/jupyterlab-vim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mart-mihkel ];
  };
}
