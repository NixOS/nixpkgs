{
  lib,
  astunparse,
  build,
  buildPythonPackage,
  execnb,
  fastcore,
  fastgit,
  fetchPypi,
  ghapi,
  ipywidgets,
  pyyaml,
  setuptools,
  watchdog,
}:

buildPythonPackage (finalAttrs: {
  pname = "nbdev";
  version = "3.3.28";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IH/PHOQxymnSiphHOt9ZPuAyotqiH40HULmvU/Gk7AQ=";
  };

  pythonRelaxDeps = [
    "fastgit"
    "ghapi"
    "ipywidgets"
  ];

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
    homepage = "https://github.com/AnswerDotAI/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    changelog = "https://github.com/AnswerDotAI/nbdev/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
