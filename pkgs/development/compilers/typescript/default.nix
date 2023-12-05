{ lib, buildNpmPackage, fetchFromGitHub}:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-lwc2bYC2f8x3Np/LxbN+5x6Apuekp7LmHXNutqL9Z2E=";
  };

  patches = [
    ./disable-dprint-dstBundler.patch
  ];

  npmDepsHash = "sha256-vD/tax5RjREdsdte3ONahVf9GPOkxPqeP9jmsxjCYkY=";

  meta = with lib; {
    description = "A superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "tsc";
  };
}
