{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "yo";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "yeoman";
    repo = "yo";
    rev = "v${version}";
    hash = "sha256-twV5vmQ5loR8j9guf0w5DG4sU4BQYz22GjqjsUkqE4U=";
  };

  npmDepsHash = "sha256-QmJDtI2PR829owY0c7DjjIwm7+TK3M/YojD0kAv1ETY=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for running Yeoman generators";
    homepage = "https://github.com/yeoman/yo";
    license = lib.licenses.bsd2;
    mainProgram = "yo";
    maintainers = [ ];
  };
}
