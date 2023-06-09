# pkgs = import (fetchTarball {
# 	url = "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
# 	sha256 = "sha256:0s4hvb6zgbi3nqnh2r4q129q4672fv65cy02mxchddz7p5hg5sma";
# }) {};

{
buildPythonPackage,
fetchFromGitHub,
pythonOlder,
poetry-core,
anyio,
attrs,
cattrs,
graphql-core,
gql,
httpx,
beartype,
platformdirs,
typing-extensions,
rich,
typer,
strawberry-graphql,
shellingham,
colorama,
} :

buildPythonPackage rec {
  pname = "dagger-io";
  version = "v0.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.10";
  
  src = fetchFromGitHub
    {
      owner = "dagger";
      repo = "dagger";
      rev = version;
      sha256 = "sha256-9QQ6aDCkTWNq5KOSGF6FH6UQrOYa51ctW3CMcGrCJAQ=";
    } + "/sdk/python";
  doCheck = false;

  propagatedBuildInputs = [
    poetry-core
    anyio
    attrs
    cattrs
    graphql-core
    gql
    httpx
    beartype
    platformdirs
    typing-extensions
    rich
    typer
    strawberry-graphql
    shellingham
    colorama
  ];
}
