{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  django,
  django-extensions,
  pytest-django,
  pytestCheckHook,
  mock,
  mock-django,
  django-autoslug,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-organizations";
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "django-organizations";
    tag = finalAttrs.version;
    hash = "sha256-MgXB2gr7tWBXpgVfxLMI0RQWwAbhXlxdzyqk7XdEsWE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-extensions
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
    mock
    mock-django
    django-autoslug
  ];

  pythonImportsCheck = [ "organizations" ];

  meta = {
    description = "Multi-user accounts for Django projects";
    homepage = "https://github.com/bennylope/django-organizations";
    changelog = "https://github.com/bennylope/django-organizations/blob/${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ defelo ];
  };
})
