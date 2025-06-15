{ lib, python, fetchFromGitHub, buildPythonPackage, }:

buildPythonPackage rec {
  pname = "django-mcp-server";
  version = "unstable-2025-06-16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "omarbenhamid";
    repo = "django-mcp-server";
    rev = "6be13da2434ba0e5a414d692b999e88122b37e0d";
    sha256 = "sha256-MaJq+NCfYuNyvDhz5oZ3po5+XkJeE1qSOwcaqJfJl+o=";
  };

  nativeBuildInputs = with python.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python.pkgs; [
    django
    djangorestframework
    inflection
    mcp
    uritemplate
  ];

  doCheck = true;

  meta = with lib; {
    description = "Django MCP Server implementation";
    homepage = "https://github.com/omarbenhamid/django-mcp-server";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ mrmebelman ];
  };
}
