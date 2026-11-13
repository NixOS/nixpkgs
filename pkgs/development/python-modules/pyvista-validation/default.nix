{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  numpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvista-validation";
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyvista";
    repo = "pyvista-validation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LuY3AYWmsETjItFdgKcK6nRm5GYlqWbrznxYO+EaUYY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "pyvista_validation"
  ];

  meta = {
    description = "Validate and standardize array-like input";
    homepage = "https://github.com/pyvista/pyvista-validation";
    changelog = "https://github.com/pyvista/pyvista-validation/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
  };
})
