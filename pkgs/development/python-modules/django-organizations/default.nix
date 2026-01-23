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
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bennylope";
    repo = "django-organizations";
    tag = version;
    hash = "sha256-lgri6CCITp1oYCwpH8vrUglphXOmwZ3KX5G/L29akrs=";
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
    maintainers = with lib.maintainers; [ defelo ];
  };
}
