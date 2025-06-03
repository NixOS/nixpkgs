{
  lib,
  buildPythonPackage,
  django-stubs,
  django,
  fetchFromGitHub,
  parameterized,
  pytest-cov-stub,
  pytest-django,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-modeltranslation";
  version = "0.19.14";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "deschler";
    repo = "django-modeltranslation";
    tag = "v${version}";
    hash = "sha256-jvVzSltq4wkSmndyyOGxldXJVpydmCCrHMGTGiMUNA0=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  nativeCheckInputs = [
    django-stubs
    pytestCheckHook
    pytest-cov-stub
    pytest-django
    parameterized
  ];

  pythonImportsCheck = [ "modeltranslation" ];

  meta = with lib; {
    description = "Translates Django models using a registration approach";
    homepage = "https://github.com/deschler/django-modeltranslation";
    changelog = "https://github.com/deschler/django-modeltranslation/blob/v${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ augustebaum ];
  };
}
