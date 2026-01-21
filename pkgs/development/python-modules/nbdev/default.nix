{
  lib,
  build,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipywidgets,
  fastcore,
  astunparse,
  watchdog,
  execnb,
  ghapi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "nbdev";
  version = "2.4.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SonqSaW/xmM91Cy0aLAkVUrXuNnkjg+ZphZF3I5ZGvQ=";
  };

  pythonRelaxDeps = [ "ipywidgets" ];

  build-system = [
    build
    setuptools
  ];

  dependencies = [
    astunparse
    execnb
    fastcore
    ghapi
    ipywidgets
    pyyaml
    watchdog
  ];

  # no real tests
  doCheck = false;

  pythonImportsCheck = [ "nbdev" ];

  meta = {
    homepage = "https://github.com/fastai/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    changelog = "https://github.com/fastai/nbdev/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
}
