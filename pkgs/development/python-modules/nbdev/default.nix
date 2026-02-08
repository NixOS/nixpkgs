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

buildPythonPackage (finalAttrs: {
  pname = "nbdev";
  version = "3.0.10";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5NPOctZ68qS7ETEr/zwRY9Q66gjVa3F7gyc7cssyI4A=";
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
    changelog = "https://github.com/fastai/nbdev/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
