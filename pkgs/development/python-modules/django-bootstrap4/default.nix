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
    (fetchpatch2 {
      name = "uv-build.patch";
      url = "https://github.com/zostera/django-bootstrap4/commit/09b14bc9b70e7da92200c4bc014e2d3c597f0ea6.patch?full_index=1";
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
