{ lib, buildNpmPackage, fetchFromGitHub, testers, typescript }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-fOA5IblxUd+C9ST3oI8IUmTTRL3exC63MPqW5hoWN0M=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-ytdkxIjAd3UsU90o9IFZa5lGEv39zblBmgTTseVRGKQ=";

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
