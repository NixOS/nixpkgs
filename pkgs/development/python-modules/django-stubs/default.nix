{
  lib,
  buildPythonPackage,
  django-stubs-ext,
  django,
  fetchFromGitHub,
  uv-build,
  redis,
  mypy,
  pytest-mypy-plugins,
  oracledb,
  pytestCheckHook,
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.9,<0.10.0" "uv_build>=0.9.9"
  '';

  build-system = [ uv-build ];

  dependencies = [
    django
    django-stubs-ext
    types-pytz
    types-pyyaml
    typing-extensions
  ];

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
