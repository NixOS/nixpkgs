{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pylint,
  pylint-plugin-utils,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pylint-celery";
  version = "0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "pylint-celery";
    tag = finalAttrs.version;
    hash = "sha256-V3mjFovlUjvOZB+ZHlbWNRf/5Qr+EnuJOIKJgFXm0BU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pylint ];

  dependencies = [ pylint-plugin-utils ];

  # Testing requires a very old version of pylint, incompatible with other dependencies
  doCheck = false;

  pythonImportsCheck = [ "pylint_celery" ];

  meta = {
    description = "Pylint plugin to analyze Celery applications";
    homepage = "https://github.com/PyCQA/pylint-celery";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
