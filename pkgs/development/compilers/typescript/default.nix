{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.2.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-wjoqDmCudN5+9C3GrP1viiXBvsWgU0UIYWaFeK/TJEY=";
  };

  npmDepsHash = "sha256-7Wm6nlpqZRNqBU0mYFZRVWQkO4uqvrKrp2h2aEmZtow=";

  meta = with lib; {
    description = "A superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "tsc";
  };
}
