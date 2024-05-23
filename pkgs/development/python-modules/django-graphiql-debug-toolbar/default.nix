{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  django,
  django-debug-toolbar,
  graphene-django,
  python,
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

  DB_BACKEND = "sqlite";
  DB_NAME = ":memory:";
  DJANGO_SETTINGS_MODULE = "tests.settings";

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django test tests
    runHook postCheck
  '';

  meta = with lib; {
    description = "Django Debug Toolbar for GraphiQL IDE";
    homepage = "https://github.com/flavors/django-graphiql-debug-toolbar";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
