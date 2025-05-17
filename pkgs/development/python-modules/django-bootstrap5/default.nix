{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  jinja2,
  pillow,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-bootstrap5";
  version = "25.1-unstable-2025-05-12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "zostera";
    repo = "django-bootstrap5";
    rev = "133bdad383af9d9c674c81ed6f96feca04841c3c";
    hash = "sha256-DHChabMfuTRAc8zX/vQxAxictTXpx/AJIKir/sfhpdA=";
  };

  build-system = [ hatchling ];

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
  ] ++ lib.flatten (lib.attrValues optional-dependencies);

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
