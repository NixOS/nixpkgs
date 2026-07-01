{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,
  python,
}:

buildPythonPackage rec {
  pname = "django-simple-history";
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-simple-history";
    tag = version;
    hash = "sha256-Uk1Uhpv3K5ZDasrUAUpI4q63DhEPN3L6Ve2WyRHai/8=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
    hatch-vcs
  ];

  dependencies = [ django ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} runtests.py
    runHook postCheck
  '';

  pythonImportsCheck = [ "simple_history" ];

  meta = {
    description = "Module to store Django model state on every create/update/delete";
    homepage = "https://github.com/jazzband/django-simple-history/";
    changelog = "https://github.com/jazzband/django-simple-history/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
