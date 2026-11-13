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

buildPythonPackage rec {
  pname = "django-organizations";
  version = "2.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "django-organizations";
    tag = "v${version}";
    hash = "sha256-q9E3Dc9Vg3OrQvzXvmz6L1SlY5Cm1wz4CkJAIR5/xA4=";
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
    changelog = "https://github.com/bennylope/django-organizations/blob/${version}/HISTORY.rst";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
