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
  version = "1.7.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "bartTC";
    repo = "django-markup";
    rev = "refs/tags/v${version}";
    hash = "sha256-NvGlvrXOwDrwHhbFHrWf7Kz9sEzTTyq84/Z6jjRNy8Q=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
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

  meta = with lib; {
    description = "Generic Django application to convert text with specific markup to html.";
    homepage = "https://github.com/bartTC/django-markup";
    changelog = "https://github.com/bartTC/django-markup/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
