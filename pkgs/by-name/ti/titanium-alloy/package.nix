{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "alloy";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "tidev";
    repo = "alloy";
    rev = version;
    hash = "sha256-s1hAbbUy7k/GacBIk8OMD48/1IUcRcpV3LnrCCZim1A=";
  };

  npmDepsHash = "sha256-YNyFrO6+oFluyk3TlUf/0vdHrgTJ3l5DN801wnpBa6s=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/tidev/alloy/blob/${src.rev}/CHANGELOG.md";
    description = "MVC framework for the Appcelerator Titanium SDK";
    homepage = "https://github.com/tidev/alloy";
    license = lib.licenses.asl20;
    mainProgram = "alloy";
    maintainers = [ ];
  };
}
