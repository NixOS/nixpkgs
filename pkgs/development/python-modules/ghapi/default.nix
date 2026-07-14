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
  version = "1.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "ghapi";
    tag = finalAttrs.version;
    hash = "sha256-H1DuoESnGtU3nsKzW3Zj0RdGNXj1bBGpt6W3mprpVeg=";
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
