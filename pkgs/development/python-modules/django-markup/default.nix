{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  django,

  # optionals
  bleach,
  docutils,
  markdown,
  pygments,
  python-creole,
  smartypants,
  textile,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-markup";
  version = "1.8.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bartTC";
    repo = "django-markup";
    rev = "refs/tags/v${version}";
    hash = "sha256-Hhcp4wVJEcYV1lEZ2jWf7nOlt5m4lVAfC6VmKIdxf4c=";
  };

  postPatch = ''
    sed -i "/--cov/d" pyproject.toml
  '';

  buildInputs = [ django ];

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

  pythonImportsCheck = [ "django_markup" ];

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
