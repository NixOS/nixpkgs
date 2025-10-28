{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pythonOlder,
  pytestCheckHook,
  setuptools,
  django-parler,
  django-cms,
  distutils,
  pytest-django,
  beautifulsoup4,
  python,
  django-app-helper,
}:

buildPythonPackage rec {
  pname = "djangocms-alias";
  version = "3.0.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "djangocms-alias";
    tag = version;
    hash = "sha256-70Gs+Ys26ypq5RXkPTxxMDFz/OCBvvAVnSIUQ3P1OV8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    django-cms
    django-parler
  ];

  checkInputs = [
    beautifulsoup4
    distutils
    django-app-helper
    pytestCheckHook
    pytest-django
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} test_settings.py
    runHook postCheck
  '';

  # Disable tests because dependency djangocms-versioning isn't packaged yet.
  doCheck = false;

  pythonImportsCheck = [ "djangocms_alias" ];

  meta = {
    description = "Lean enterprise content management powered by Django";
    homepage = "https://django-cms.org";
    changelog = "https://github.com/django-cms/djangocms-alias/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.onny ];
  };
}
