{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
  djangorestframework,
  inflection,
  mcp,
  uritemplate,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "django-mcp-server";
  version = "0.5.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "omarbenhamid";
    repo = "django-mcp-server";
    tag = "v${version}";
    hash = "sha256-MaJq+NCfYuNyvDhz5oZ3po5+XkJeE1qSOwcaqJfJl+o=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    django
    djangorestframework
    inflection
    mcp
    uritemplate
  ];

  postFixup = ''
    export PYTHONPATH="$PWD/examples:$PYTHONPATH"
    export DJANGO_SETTINGS_MODULE=mcpexample.mcpexample.settings
  '';

  pythonImportsCheck = [ "mcp_server" ];

  doCheck = false; # Needs to run both test server and client simultaneously

  meta = {
    description = "Django MCP Server implementation";
    homepage = "https://github.com/omarbenhamid/django-mcp-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
