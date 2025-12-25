{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  hatch-vcs,
  python,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-simple-history";
  version = "3.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-simple-history";
    tag = version;
    hash = "sha256-pTWorV++YSr/oIdcShrJTBUFfn5ekJ29rNn6ltDhN5Q=";
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
