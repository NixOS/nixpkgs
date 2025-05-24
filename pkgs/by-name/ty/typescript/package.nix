{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  typescript,
}:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.8.3";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-/XxjZO/pJLLAvsP7x4TOC+XDbOOR+HHmdpn+8qP77L8=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-/LkIqwuG0px/vbif9mVL9lHpv5KX8SaS7fD+4wiNaIA=";

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
