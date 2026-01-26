{
  lib,
  build,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipywidgets,
  fastcore,
  fastgit,
  astunparse,
  watchdog,
  execnb,
  ghapi,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "nbdev";
  version = "2.4.14";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zXUbUFf08IncbDO6sHiZP6KFvhF3d+GsFLPp2EuAW3g=";
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
    fastgit
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
