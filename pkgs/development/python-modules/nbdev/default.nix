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
  version = "3.0.17";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Tp+CiwTSCr6KWxobeD6MjD/YJ2cOUd+jgavlwXJ7Ucc=";
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
    homepage = "https://github.com/AnswerDotAI/nbdev";
    description = "Create delightful software with Jupyter Notebooks";
    changelog = "https://github.com/AnswerDotAI/nbdev/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
  };
})
