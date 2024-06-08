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
  pytestCheckHook,
  pytest-django,
}:

buildPythonPackage rec {
  pname = "django-pattern-library";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "torchbox";
    repo = "django-pattern-library";
    rev = "refs/tags/v${version}";
    hash = "sha256-hrdJYVioY6y9D29DuKPMZjdWj92GcbHXANWiEHadimI=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
    django
    pyyaml
    markdown
  ];

  nativeCheckInputs = [
    beautifulsoup4
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
