{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "wsl";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "bombsimon";
    repo = "wsl";
    rev = "v${version}";
    hash = "sha256-oyTDfYQ+kEfpGUVCB3C1Nkm7f1Udd9+0yw9efy9ijdU=";
  };

  vendorHash = "sha256-UnfM+KMHw2EPrjnj03RVv3T3wAk/G8f+spg3Vo9tn/4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Whitespace Linter - Forces you to use empty lines";
    homepage = "https://github.com/bombsimon/wsl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ meain ];
    mainProgram = "wsl";
  };
}
