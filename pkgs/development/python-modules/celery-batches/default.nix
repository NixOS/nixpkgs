{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clokep";
    repo = "celery-batches";
    tag = "v${version}";
    hash = "sha256-w7k8VPtJf9VRB8lJC/ENk3kIMPITd+qRIXm1KrCktgc=";
  };

  build-system = [ setuptools ];

  dependencies = [ celery ];

  # requires a running celery
  doCheck = false;

  pythonImportsCheck = [ "celery_batches" ];

  meta = {
    description = "Allows processing of multiple Celery task requests together";
    homepage = "https://github.com/clokep/celery-batches";
    changelog = "https://github.com/clokep/celery-batches/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
