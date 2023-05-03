{ lib
, buildPythonPackage
, fetchFromGitHub
, django

# optionals
, bleach
, docutils
, markdown
, pygments
, python-creole
, smartypants
, textile

# tests
, pytest-django
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-markup";
  version = "1.6";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bartTC";
    repo = "django-markup";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hh+3KxFE6sSIqRowyZ1Pz6NmBaTbltZaEhSjFrw760Q=";
  };

  postPatch = ''
    sed -i "/--cov/d" setup.cfg
  '';

  buildInputs = [
    django
  ];

  passthru.optional-dependencies = {
    all_filter_dependencies = [
      bleach
      docutils
      markdown
      pygments
      python-creole
      smartypants
      textile
    ];
  };

  pythonImportsCheck = [
    "django_markup"
  ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ] ++ passthru.optional-dependencies.all_filter_dependencies;

  env.DJANGO_SETTINGS_MODULE = "django_markup.tests";

  disabledTests = [
    # https://github.com/bartTC/django-markup/issues/40
    "test_rst_with_pygments"
  ];

  meta = with lib; {
    description = "Generic Django application to convert text with specific markup to html.";
    homepage = "https://github.com/bartTC/django-markup";
    changelog = "https://github.com/bartTC/django-markup/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
