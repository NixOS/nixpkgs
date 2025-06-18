{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-03-26";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "a5fe55684d52b017a494471a2a08264d778166ad";
    hash = "sha256-e8tDQOr6CtGjVhhiPjSG14adrqi5geBitD1SnqL6Tx8=";
  };

  vendorHash = "sha256-iWY0b6PAw9BhA8WrTEECnVAKWTGXuIiGvOi9uhJO4PI=";

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "txtpbfmt";
  };
}
