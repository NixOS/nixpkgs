{ lib, buildNpmPackage, fetchFromGitHub, testers, typescript }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.7.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-Lm7p27DgRWKY+auH6LIz8SIUfvPyQpel0xvkXgzlCzU=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-4w2CzEMrbfiSveTc/IH6O1twG9vkBkOxAIxJ8swXgNU=";

  passthru.tests = {
    version = testers.testVersion {
      package = typescript;
    };
  };

  meta = with lib; {
    description = "Superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "tsc";
  };
}
