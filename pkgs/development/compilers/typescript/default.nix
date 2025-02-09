{ lib, buildNpmPackage, fetchFromGitHub, testers, typescript }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-gZdS4TGbafaOdNc1ZB24uAjMu9g0hef6mEsOr/dPqvY=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-gj59jjko13UBPqqy/3z1KgVMFUQPUAIg47UTTaseF+w=";

  passthru.tests = {
    version = testers.testVersion {
      package = typescript;
    };
  };

  meta = with lib; {
    description = "A superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "tsc";
  };
}
