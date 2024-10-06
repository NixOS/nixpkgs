{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, wheel
, celery
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clokep";
    repo = "celery-batches";
    rev = "v${version}";
    hash = "sha256-w7k8VPtJf9VRB8lJC/ENk3kIMPITd+qRIXm1KrCktgc=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    celery
  ];

  pythonImportsCheck = [ "celery_batches" ];

  meta = {
    description = "Celery Batches allows processing of multiple Celery task requests together";
    homepage = "https://github.com/clokep/celery-batches";
    changelog = "https://github.com/clokep/celery-batches/blob/${src.rev}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ soyouzpanda ];
    mainProgram = "celery-batches";
  };
}
