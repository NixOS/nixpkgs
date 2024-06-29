{ lib, buildNpmPackage, fetchFromGitHub, testers, typescript }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-2BgMzOW9DIIncujAVJ/C8L9aMwDkNaj47cV2JSxCPrw=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-/WQgSoklW1szgJ/5iN0Dg+L7BMByvyc+KcvYiQNjGEw=";

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
