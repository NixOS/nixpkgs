{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "terminal-parrot";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "jmhobbs";
    repo = "terminal-parrot";
    rev = version;
    hash = "sha256-VOV1KKaZrKyz+Fj//RbPrBE3ImC60FNauayVAMmoxFc=";
  };

  vendorHash = "sha256-EhnmOpT+rx4RVpmqgEQ4qO+Uca1W9uhx4fcExXG9LOI=";

  doCheck = false;

  meta = with lib; {
    description = "Shows colorful, animated party parrot in your terminial";
    homepage = "https://github.com/jmhobbs/terminal-parrot";
    license = licenses.mit;
    maintainers = [ maintainers.heel ];
    mainProgram = "terminal-parrot";
  };
}
