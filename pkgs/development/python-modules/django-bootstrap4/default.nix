{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,

  # build-system
  uv-build,

  # non-propagates
  django,

  # dependencies
  beautifulsoup4,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-bootstrap4";
  version = "25.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap4";
    tag = "v${version}";
    hash = "sha256-+G9UHW4eUGl00A/kDj+iTP7ehjj/dwUENKffvGxE6/4=";
  };

  patches = [
    # https://github.com/zostera/django-bootstrap4/pull/826
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/Prince213/django-bootstrap4/commit/e3e6b7cc6720568177d37ff0998007c84c294c5a.patch?full_index=1";
      hash = "sha256-ZW9y8n0ZCOP37EoP32e7ue6h93KgGw1pW8Q1Q8IuNk8=";
    })
  ];

  build-system = [ uv-build ];

  dependencies = [ beautifulsoup4 ];

  pythonImportsCheck = [ "bootstrap4" ];

  nativeCheckInputs = [
    (django.override { withGdal = true; })
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.app.settings
  '';

  meta = with lib; {
    description = "Bootstrap 4 integration with Django";
    homepage = "https://github.com/zostera/django-bootstrap4";
    changelog = "https://github.com/zostera/django-bootstrap4/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ hexa ];
  };
}
