{
  lib,
  buildPythonPackage,
  fastcore,
  fetchPypi,
  ipython,
  setuptools,
  traitlets,
}:

buildPythonPackage (finalAttrs: {
  pname = "execnb";
  version = "0.3.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-0Ca35QfhrNEyBdYf9KCl5tBJjOPDla79h8W0oOGHWu0=";
  };

  pythonRelaxDeps = [ "fastcore" ];

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    ipython
    traitlets
  ];

  # no real tests
  doCheck = false;

  pythonImportsCheck = [ "execnb" ];

  meta = {
    description = "Execute a jupyter notebook, fast, without needing jupyter";
    homepage = "https://github.com/fastai/execnb";
    changelog = "https://github.com/fastai/execnb/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rxiao ];
    mainProgram = "exec_nb";
  };
})
