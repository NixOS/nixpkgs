{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clokep";
    repo = "celery-batches";
    tag = "v${version}";
    hash = "sha256-9RpM2aC3F88fJBoW8FDd6IN8KlZN+6ESrZFak9j0eNk=";
  };

  build-system = [ setuptools ];

  dependencies = [ celery ];

  # requires a running celery
  doCheck = false;

  pythonImportsCheck = [ "celery_batches" ];

  meta = {
    description = "Allows processing of multiple Celery task requests together";
    homepage = "https://github.com/clokep/celery-batches";
    changelog = "https://github.com/clokep/celery-batches/blob/${src.tag}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ defelo ];
  };
}
