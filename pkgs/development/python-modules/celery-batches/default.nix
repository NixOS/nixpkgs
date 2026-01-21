{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  celery,
}:

buildPythonPackage rec {
  pname = "celery-batches";
  version = "0.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "clokep";
    repo = "celery-batches";
    tag = "v${version}";
    hash = "sha256-+1cpauali+MjDox0esw0+bveOEroIQ0DkuHQuwm/i4Q=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    # https://github.com/clokep/celery-batches/pull/100
    "celery"
  ];

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
