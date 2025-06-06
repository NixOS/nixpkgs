{ lib, buildNpmPackage, fetchFromGitHub, testers, typescript }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-2yfF14hR/avl67cOwo+Gr95w2jf+7KYlsMrlBTAKswM=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-YihnUZgM+74EmImalyTFtp9xyiOOfjZVohDfpcvlSEg=";

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
