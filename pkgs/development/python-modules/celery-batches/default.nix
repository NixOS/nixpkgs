{ lib
, fetchFromGitHub
, buildPythonPackage
, setuptools
, wheel
, celery
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clokep";
    repo = "celery-batches";
    rev = "v${version}";
    hash = "sha256-tyLeulimbH7a1B5vC4qMJSC9sczejw6D99UnS/q7bpk=";
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
