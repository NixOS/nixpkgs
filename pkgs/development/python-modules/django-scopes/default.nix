{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pytestCheckHook,
  pytest-django,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-scopes";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "raphaelm";
    repo = "django-scopes";
    tag = finalAttrs.version;
    hash = "sha256-D04SqB+k7XnbkUY4ekrY7sz63DOcJlcaLR9kWhfxMco=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  pythonImportsCheck = [ "django_scopes" ];

  meta = {
    description = "Safely separate multiple tenants in a Django database";
    homepage = "https://github.com/raphaelm/django-scopes";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ambroisie ];
  };
})
