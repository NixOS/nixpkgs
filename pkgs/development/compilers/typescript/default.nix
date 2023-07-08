{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "typescript";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "TypeScript";
    rev = "v${version}";
    hash = "sha256-YBAAiO7MBJ41VK6A9zeExB7ZSbbrQ23sVTHAqo+/H/w=";
  };

  npmDepsHash = "sha256-RHiUhhkzkr2Ra3wc1d13gE2WIZL49w7IEFEAZuBDTDI=";

  meta = with lib; {
    description = "A superset of JavaScript that compiles to clean JavaScript output";
    homepage = "https://www.typescriptlang.org/";
    changelog = "https://github.com/microsoft/TypeScript/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
    mainProgram = "tsc";
  };
}
