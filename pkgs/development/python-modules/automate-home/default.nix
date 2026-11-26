{
  lib,
  apscheduler,
  buildPythonPackage,
  ephem,
  fetchFromGitHub,
  hiredis,
  pytestCheckHook,
  pytz,
  pyyaml,
  redis,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "automate-home";
  version = "0.9.1-unstable-2026-11-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "majamassarini";
    repo = "automate-home";
    rev = "79f5212df30924812c91dc40d709dd60ae6c4467";
    hash = "sha256-6TsUHTZ2iZEe9ULCRbHjbDQIquPULOCAVZ0t9d8+z9I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    apscheduler
    ephem
    hiredis
    pytz
    pyyaml
    redis
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "home" ];

  meta = {
    description = "Python module to automate (home) devices";
    homepage = "https://github.com/majamassarini/automate-home";
    changelog = "https://github.com/majamassarini/automate-home/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
