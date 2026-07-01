{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fastcore,
  packaging,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ghapi";
  version = "1.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    tag = finalAttrs.version;
    hash = "sha256-vVGVX8mWzEenaoDYGd4RjD/u2k/N9Ajm/pheKHPNEWM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    fastcore
    packaging
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "ghapi" ];

  meta = {
    description = "Python interface to GitHub's API";
    homepage = "https://github.com/fastai/ghapi";
    changelog = "https://github.com/fastai/ghapi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
