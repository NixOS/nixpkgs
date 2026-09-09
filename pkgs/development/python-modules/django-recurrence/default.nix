{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  python-dateutil,
  pytest-django,
  pytestCheckHook,
  pytest-cov-stub,
  pdm-backend,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-recurrence";
  version = "1.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "django-recurrence";
    tag = finalAttrs.version;
    hash = "sha256-Hw9QebQuQfhooa6rhJ1+y7DTgPgaVF9kZzQ9H7NshmM=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    django
    python-dateutil
  ];

  pythonImportsCheck = [ "recurrence" ];

  nativeCheckInputs = [
    pytest-django
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Utility for working with recurring dates in Django";
    homepage = "https://github.com/jazzband/django-recurrence";
    changelog = "https://github.com/jazzband/django-recurrence/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
