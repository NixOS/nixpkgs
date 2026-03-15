{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  lib,
  django,
  py-moneyed,
  certifi,
  pytestCheckHook,
  pytest-django,
  pytest-cov,
}:
buildPythonPackage rec {
  pname = "django-money";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-money";
    repo = "django-money";
    tag = version;
    hash = "sha256-VxAKTtrbDMRhiLxqjVYt7pLGl0sy9F1iwswP/hxQ01k=";
  };

  dependencies = [
    django
    certifi
    py-moneyed
  ];

  build-system = [ setuptools ];
  doCheck = true;
  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    pytest-cov
  ];
  pythonImportsCheck = [ "djmoney" ];

  # avoid tests which import mixer, an abandoned library
  disabledTests = [
    "test_mixer_blend"
  ];

  meta = with lib; {
    description = "Money fields for Django forms and models.";
    homepage = "https://github.com/django-money/django-money";
    changelog = "https://github.com/django-money/django-money/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kurogeek ];
  };
}
