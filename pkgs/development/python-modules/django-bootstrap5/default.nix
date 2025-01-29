{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  jinja2,
  pillow,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-bootstrap5";
  version = "24.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap5";
    rev = "v${version}";
    hash = "sha256-8e0Pi4uSvQhiLYiMgOqWJWDc/KPMXxyU5pnT9jvFZLU=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ django ];

  optional-dependencies = {
    jinja = [ jinja2 ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    (django.override { withGdal = true; })
    pillow
    pytest-django
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.app.settings
  '';

  disabledTests = [
    # urllib.error.URLError: <urlopen error [Errno -3] Temporary failure in name resolution>
    "test_get_bootstrap_setting"
  ];

  pythonImportsCheck = [ "django_bootstrap5" ];

  meta = with lib; {
    description = "Bootstrap 5 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap5";
    changelog = "https://github.com/zostera/django-bootstrap5/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ netali ];
  };
}
