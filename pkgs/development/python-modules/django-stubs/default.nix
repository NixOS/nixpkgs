{
  lib,
  buildPythonPackage,
  django-stubs-ext,
  django,
  fetchFromGitHub,
  hatchling,
  redis,
  mypy,
  pytest-mypy-plugins,
  oracledb,
  pytestCheckHook,
  pythonOlder,
  tomli,
  types-pytz,
  types-pyyaml,
  types-redis,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs";
  version = "5.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "django-stubs";
    tag = version;
    hash = "sha256-42FluS2fmfgj4qk2u+Z/7TGhXY4WKUc0cI00go6rnGc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    django-stubs-ext
    types-pytz
    types-pyyaml
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  optional-dependencies = {
    compatible-mypy = [ mypy ];
    oracle = [ oracledb ];
    redis = [
      redis
      types-redis
    ];
  };

  nativeCheckInputs = [
    pytest-mypy-plugins
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  disabledTests = [
    # AttributeError: module 'django.contrib.auth.forms' has no attribute 'SetUnusablePasswordMixin'
    "test_find_classes_inheriting_from_generic"
  ];

  disabledTestPaths = [
    # Skip type checking
    "tests/typecheck/"
  ];

  pythonImportsCheck = [ "django-stubs" ];

  meta = {
    description = "PEP-484 stubs for Django";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
