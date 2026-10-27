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
  version = "3.3.12";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-D5je848qb6oYy60LwZGAbJAmt1GMiBSnXYsPPquWfaE=";
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
