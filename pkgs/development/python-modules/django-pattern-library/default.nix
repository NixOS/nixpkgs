{
  buildPythonPackage,
  fetchFromGitHub,
  lib,

  # build-system
  poetry-core,

  # dependencies
  django,
  markdown,
  pyyaml,

  # tests
  beautifulsoup4,
  jinja2,
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-pattern-library";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "torchbox";
    repo = "django-pattern-library";
    tag = "v${version}";
    hash = "sha256-urK34rlBU5GuEOlUtmJLGv6wlTP5H/RMAkwQu5S2Jbo=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    pyyaml
    markdown
  ];

  nativeCheckInputs = [
    beautifulsoup4
    jinja2
    pytestCheckHook
    pytest-django
  ];

  env.DJANGO_SETTINGS_MODULE = "tests.settings.dev";

  pythonImportsCheck = [ "pattern_library" ];

  meta = with lib; {
    description = "UI pattern libraries for Django templates";
    homepage = "https://github.com/torchbox/django-pattern-library/";
    changelog = "https://github.com/torchbox/django-pattern-library/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sephi ];
  };
}
