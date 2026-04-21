{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  django,
  django-appconf,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-select2";
  version = "8.4.8";
  src = fetchFromGitHub {
    owner = "codingjoe";
    repo = "django-select2";
    tag = finalAttrs.version;
    hash = "sha256-bY5pURtJD3gplFqIknAMEDpjtdQN25hLEaqBf+Wme7Q=";
  };

  pyproject = true;
  build-system = [ flit-scm ];

  dependencies = [
    django
    django-appconf
  ];

  meta = {
    description = "Custom autocomplete fields for Django";
    homepage = "https://github.com/codingjoe/django-select2";
    changelog = "https://github.com/codingjoe/django-select2/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dav-wolff ];
  };
})
