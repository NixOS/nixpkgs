{ lib
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage rec {
  pname = "write-good";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "btford";
    repo = "write-good";
    rev = "v${version}";
    hash = "sha256-cq3cj2BwoQMKqo3iU2l+PR/2bJIFMSTRsDGQJ06GWXk=";
  };

  npmDepsHash = "sha256-0M9RzyeINmUPYcLy654iI+/ehElKrhIAibpiSqlXD2A=";

  dontNpmBuild = true;

  meta = {
    description = "Naive linter for English prose";
    homepage = "https://github.com/btford/write-good";
    license = lib.licenses.mit;
    mainProgram = "write-good";
    maintainers = [ ];
  };
}
