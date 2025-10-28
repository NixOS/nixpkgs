{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  django,
  tablib,

  # tests
  django-filter,
  lxml,
  openpyxl,
  psycopg2,
  pytz,
  pyyaml,
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-tables2";
  version = "2.7.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jieter";
    repo = "django-tables2";
    tag = "v${version}";
    hash = "sha256-Cb8XhCLqhc2Dx/5uAHnN9zTVL6/1+WekC4qTloBurzM=";
  };

  build-system = [ hatchling ];

  dependencies = [ django ];

  optional-dependencies = {
    tablib = [ tablib ] ++ tablib.optional-dependencies.xls ++ tablib.optional-dependencies.yaml;
  };

  env.DJANGO_SETTINGS_MODULE = "tests.app.settings";

  nativeCheckInputs = [
    django-filter
    lxml
    openpyxl
    psycopg2
    pytz
    pyyaml
    pytest-django
    pytestCheckHook
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  meta = with lib; {
    changelog = "https://github.com/jieter/django-tables2/blob/v${version}/CHANGELOG.md";
    description = "Django app for creating HTML tables";
    homepage = "https://github.com/jieter/django-tables2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
