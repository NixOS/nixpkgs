{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "cf07efcaeff78f7d945f844d506daf4cad5a9229";
    hash = "sha256-A/rmMtYLaTEkP02DLaYu/1nwaQ7EWacvcl0ri5Zx5zs=";
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
