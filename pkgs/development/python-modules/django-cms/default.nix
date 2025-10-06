{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  setuptools,
  django-classy-tags,
  django-formtools,
  django-treebeard,
  django-sekizai,
  djangocms-admin-style,
  python,
  dj-database-url,
  djangocms-text-ckeditor,
  fetchpatch,
  django-cms,
  gettext,
  iptools,
}:

buildPythonPackage rec {
  pname = "django-cms";
  version = "5.0.4";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "django-cms";
    tag = version;
    hash = "sha256-bhF1FJO+EHg49ZnwykVmyM/kkdXMCyfoV+EFQ5IZFF4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-classy-tags
    django-formtools
    django-treebeard
    django-sekizai
    djangocms-admin-style
  ];

  nativeCheckInputs = [ gettext ];

  checkInputs = [
    dj-database-url
    djangocms-text-ckeditor
    iptools
  ];

  preCheck = ''
    # Disable ruff formatter test
    rm cms/tests/test_static_analysis.py
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} manage.py test
    runHook postCheck
  '';

  # Tests depend on djangocms-text-ckeditor and djangocms-admin-style,
  # which depends on this package.
  # To avoid infinite recursion, we only enable tests when building passthru.tests.
  doCheck = false;

  passthru.tests = {
    runTests = django-cms.overridePythonAttrs (_: {
      doCheck = true;
    });
  };

  pythonImportsCheck = [ "cms" ];

  meta = {
    description = "Lean enterprise content management powered by Django";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/django-cms/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
