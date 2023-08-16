{ lib
, anyio
, attrs
, beartype
, buildPythonPackage
, cattrs
, colorama
, fetchFromGitHub
, gql
, graphql-core
, httpx
, platformdirs
, poetry-core
, pythonOlder
, rich
, shellingham
, strawberry-graphql
, typer
, typing-extensions
}:

buildPythonPackage rec {
  pname = "dagger-io";
  version = "0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
      owner = "dagger";
      repo = "dagger";
      rev = "v${version}";
      sha256 = "sha256-9QQ6aDCkTWNq5KOSGF6FH6UQrOYa51ctW3CMcGrCJAQ=";
  } + "/sdk/python";

  propagatedBuildInputs = [
    anyio
    attrs
    beartype
    cattrs
    colorama
    gql
    graphql-core
    httpx
    platformdirs
    poetry-core
    rich
    shellingham
    strawberry-graphql
    typer
    typing-extensions
  ];
  meta = with lib; {
    description = "Dagger is a programmable CI/CD engine that runs your pipelines in containers.";
    homepage = "https://github.com/dagger/dagger";
    changelog = "https://github.com/dagger/dagger/releases/tag/v${version}";
    license = licenses.asl20 ;
    maintainers = with maintainers; [ rayanpiro ];
  };
}
