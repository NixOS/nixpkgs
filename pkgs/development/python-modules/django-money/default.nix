{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  lib,
  py-moneyed,
  django,
  certifi,
  pytestCheckHook,
  pytest-django,
  pytest-cov-stub,
}:
buildPythonPackage (finalAttrs: {
  pname = "django-money";
  version = "3.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-money";
    repo = "django-money";
    tag = finalAttrs.version;
    hash = "sha256-VxAKTtrbDMRhiLxqjVYt7pLGl0sy9F1iwswP/hxQ01k=";
  };

  build-system = [ setuptools ];

  dependencies = [
    django
    py-moneyed
  ];

  optional-dependencies = {
    exchange = [ certifi ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-django
    pytest-cov-stub
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "djmoney" ];

  disabledTests = [
    # avoid tests which import mixer, an abandoned library
    "test_mixer_blend"
  ];

  meta = {
    description = "Money fields for Django forms and models";
    homepage = "https://github.com/django-money/django-money";
    changelog = "https://github.com/django-money/django-money/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kurogeek ];
  };
})
