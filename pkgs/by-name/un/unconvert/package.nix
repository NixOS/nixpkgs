{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "unconvert";
  version = "0-unstable-2026-08-16";

  src = fetchFromGitHub {
    owner = "mdempsky";
    repo = "unconvert";
    rev = "33842c47157aa10fcb7bf53e7f67e1bad15b0ecc";
    hash = "sha256-cxjMdxB1W5HlTZ5MDithCpg5kS0N32uIvm0/Eik6l6k=";
  };

  vendorHash = "sha256-l4DAb6TziWjGbQ6AS6l2wH6VLTuOS5MJiXx+pp1JKk4=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script { extraArgs = lib.singleton "--version=branch"; };

  meta = {
    description = "Remove unnecessary type conversions from Go source";
    mainProgram = "unconvert";
    homepage = "https://github.com/mdempsky/unconvert";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kalbasit ];
  };
}
