{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terminal-parrot";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = version;
    hash = "sha256-LI67DDcK3M084r9JPx8NcBWthaiBOCEL4lQJhuUJSok=";
  };

  vendorHash = "sha256-EhnmOpT+rx4RVpmqgEQ4qO+Uca1W9uhx4fcExXG9LOI=";

  doCheck = false;

  meta = {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = "https://github.com/jmhobbs/terminal-parrot";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.heel ];
    mainProgram = "terminal-parrot";
  };
}
