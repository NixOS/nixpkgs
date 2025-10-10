{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  nix-update-script,

  # build-system
  flit-gettext,
  flit-scm,

  # dependencies
  django,

  # tests
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-hijack";
  version = "3.7.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-hijack";
    repo = "django-hijack";
    tag = version;
    hash = "sha256-0gcrV1mlodnX79vZUVAIzJaOqM+WpIy0uH4Y/Cmu2lM=";
  };

  build-system = [
    flit-gettext
    flit-scm
  ];

  dependencies = [ django ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-django
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.test_app.settings
  '';

  # needed for npmDeps update
  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Allows superusers to hijack (=login as) and work on behalf of another user";
    homepage = "https://github.com/django-hijack/django-hijack";
    changelog = "https://github.com/django-hijack/django-hijack/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ ris ];
  };
}
