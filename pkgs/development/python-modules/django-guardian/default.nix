{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django-environ,
  django,
  pytestCheckHook,
  pytest-django,
  pytest-xdist,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-guardian";
  version = "3.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-guardian";
    repo = "django-guardian";
    tag = finalAttrs.version;
    hash = "sha256-viqICF6zfJxAj1jEYtBXCR2NbUR26Q8SeKVFTMVzisQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-environ
    pytestCheckHook
    pytest-django
    pytest-xdist
  ];

  pythonImportsCheck = [ "guardian" ];

  meta = {
    changelog = "https://github.com/django-guardian/django-guardian/releases/tag/${finalAttrs.src.tag}";
    description = "Per object permissions for Django";
    homepage = "https://github.com/django-guardian/django-guardian";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
