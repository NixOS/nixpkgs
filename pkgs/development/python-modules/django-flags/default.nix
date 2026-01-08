{
  buildPythonPackage,
  coverage,
  django,
  django-debug-toolbar,
  fetchFromGitHub,
  jinja2,
  lib,
  pytest-django,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "django-flags";
  version = "5.0.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cfpb";
    repo = "django-flags";
    tag = version;
    hash = "sha256-0IOcpl8OamNlalqNqMvmx/bkuIkaNnLwCD7nFclR8S4=";
  };

  dependencies = [
    django
  ];

  disabled = pythonOlder "3.8";

  build-system = [
    setuptools
    setuptools-scm
  ];
  doCheck = true;
  preCheck = ''
    export DJANGO_SETTINGS_MODULE=flags.tests.settings
  '';
  pythonImportsCheck = [ "flags" ];
  nativeCheckInputs = [
    coverage
    (django-debug-toolbar.overrideAttrs (old: rec {
      version = "5.2.0";
      src = old.src.override {
        tag = version;
        hash = "sha256-/oWirfJaiHVRI1m3N1QveutX2sag8fjYqJYCZ8BnMa0=";
      };
    }))
    jinja2
    pytest-django
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Feature flags for Django projects";
    homepage = "https://github.com/cfpb/django-flags";
    changelog = "https://github.com/cfpb/django-flags/releases/tag/${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ kurogeek ];
  };
}
