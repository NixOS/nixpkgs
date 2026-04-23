{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
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
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-cms";
    repo = "djangocms-alias";
    tag = version;
    hash = "sha256-10QS2dAFRtM2W/BMkF5Pjr70ZpdLAIC/ZE3OUatu5u0=";
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
