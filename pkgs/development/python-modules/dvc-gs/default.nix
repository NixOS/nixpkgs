{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  gcsfs,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "dvc-gs";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "dvc_gs";
    inherit (finalAttrs) version;
    hash = "sha256-QhhWD/HVGW/Qx5FiZVzXnFE0+mHr40o6UH+vB0kibu4=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    gcsfs
    dvc-objects
  ];

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #   "dvc_gs"
  # ];

  meta = {
    description = "gs plugin for dvc";
    homepage = "https://pypi.org/project/dvc-gs/version";
    changelog = "https://github.com/iterative/dvc-gs/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
