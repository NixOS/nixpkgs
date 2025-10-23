{
  lib,
  buildPythonPackage,
  django,
  fetchFromGitHub,
  hatchling,
  oracledb,
  pytest-mypy-plugins,
  pytest-xdist,
  pytestCheckHook,
  redis,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "django-stubs-ext";
  version = "5.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "django-stubs";
    tag = version;
    hash = "sha256-v+MlMy9XABb9gw3U6Xv+aXXF6AZuvu+OBdU5+8tE9Oo=";
  };

  postPatch = ''
    cd ext
    ln -s ../scripts
  '';

  build-system = [ hatchling ];

  dependencies = [
    django
    typing-extensions
  ];

  optional-dependencies = {
    redis = [ redis ];
    oracle = [ oracledb ];
  };

  nativeCheckInputs = [
    pytest-mypy-plugins
    pytest-xdist
    pytestCheckHook
  ];

  disabledTestPaths = [
    # error: Skipping analyzing "django.db": module is installed, but missing library stubs or py.typed marker  [import-untyped] (diff)
    "tests/typecheck"
  ];

  # Tests are not shipped with PyPI

  pythonImportsCheck = [ "django_stubs_ext" ];

  meta = with lib; {
    description = "Extensions and monkey-patching for django-stubs";
    homepage = "https://github.com/typeddjango/django-stubs";
    changelog = "https://github.com/typeddjango/django-stubs/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
