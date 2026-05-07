{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "terminal-parrot";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = finalAttrs.version;
    hash = "sha256-VOV1KKaZrKyz+Fj//RbPrBE3ImC60FNauayVAMmoxFc=";
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
})
