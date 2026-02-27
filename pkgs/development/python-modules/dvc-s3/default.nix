{
  lib,
  buildPythonPackage,
  dvc-objects,
  fetchPypi,
  flatten-dict,
  s3fs,
  setuptools-scm,
  funcy,
}:

buildPythonPackage rec {
  pname = "dvc-s3";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "dvc_s3";
    inherit version;
    hash = "sha256-8dcYpE3O5Rkb60bkSt9LsiiCy46czdjyZAB4q8VkV9Q=";
  };

  # Prevent circular dependency
  pythonRemoveDeps = [ "dvc" ];

  build-system = [ setuptools-scm ];

  dependencies = [
    dvc-objects
    flatten-dict
    s3fs
    funcy
  ];

  # Network access is needed for tests
  doCheck = false;

  # Circular dependency
  # pythonImportsCheck = [
  #   "dvc_s3"
  # ];

  meta = {
    description = "S3 plugin for dvc";
    homepage = "https://pypi.org/project/dvc-s3/${version}";
    changelog = "https://github.com/iterative/dvc-s3/releases/tag/${version}";
    license = lib.licenses.asl20;
  };
}
