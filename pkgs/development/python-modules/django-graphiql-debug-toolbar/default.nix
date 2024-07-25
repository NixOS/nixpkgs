{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  django,
  django-debug-toolbar,
  graphene-django,

  # tests
  python,
  pytest-django,
  pytestCheckHook
}:

buildPythonPackage rec {
  pname = "django-graphiql-debug-toolbar";
  version = "0.2.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "flavors";
    repo = pname;
    rev = version;
    sha256 = "0fikr7xl786jqfkjdifymqpqnxy4qj8g3nlkgfm24wwq0za719dw";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [
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
