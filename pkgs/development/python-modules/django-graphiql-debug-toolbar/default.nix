{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  poetry-core,

  # dependencies
  django,
  django-debug-toolbar,
  graphene-django,

  # tests
  pytest-django,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "django-graphiql-debug-toolbar";
  version = "0.2.0";
  pyproject = true;
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "flavors";
    repo = pname;
    rev = version;
    sha256 = "0fikr7xl786jqfkjdifymqpqnxy4qj8g3nlkgfm24wwq0za719dw";
  };

  patches = [
    # Add compatibility for py-django-debug-toolbar >= 4.4.6
    # https://github.com/flavors/django-graphiql-debug-toolbar/pull/27
    (fetchpatch {
      url = "https://github.com/flavors/django-graphiql-debug-toolbar/commit/2b42fdb1bc40109d9bb0ae1fb4d2163d13904724.patch";
      hash = "sha256-ywTLqXlAxA2DCacrJOqmB7jSzfpeuGTX2ETu0fKmhq4=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    django
    django-debug-toolbar
    graphene-django
  ];

  pythonImportsCheck = [ "graphiql_debug_toolbar" ];

  nativeCheckInputs = [
    pytest-django
    pytestCheckHook
  ];

  preCheck = ''
    export DB_BACKEND=sqlite
    export DB_NAME=:memory:
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  meta = with lib; {
    changelog = "https://github.com/flavors/django-graphiql-debug-toolbar/releases/tag/${src.rev}";
    description = "Django Debug Toolbar for GraphiQL IDE";
    homepage = "https://github.com/flavors/django-graphiql-debug-toolbar";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
