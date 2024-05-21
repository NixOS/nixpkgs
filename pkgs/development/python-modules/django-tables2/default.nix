{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub

# build-system
, setuptools

# dependencies
, django
, tablib

# tests
, lxml
, openpyxl
, psycopg2
, pytz
, pyyaml
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-tables2";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "jieter";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VB7xmcBncTUYllzKS4o7G7u+KoivMiiEQGZ4x+Rnces=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    django
  ];

  passthru.optional-dependencies = {
    tablib = [
      tablib
    ]
    ++ tablib.optional-dependencies.xls
    ++ tablib.optional-dependencies.yaml;
  };

  env.DJANGO_SETTINGS_MODULE = "tests.app.settings";

  nativeCheckInputs = [
    lxml
    openpyxl
    psycopg2
    pytz
    pyyaml
    pytest-django
    pytestCheckHook
  ] ++ lib.flatten (lib.attrValues passthru.optional-dependencies);

  disabledTestPaths = [
    # requires django-filters
    "tests/test_views.py"
  ];

  meta = with lib; {
    changelog = "https://github.com/jieter/django-tables2/blob/v${version}/CHANGELOG.md";
    description = "Django app for creating HTML tables";
    homepage = "https://github.com/jieter/django-tables2";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
