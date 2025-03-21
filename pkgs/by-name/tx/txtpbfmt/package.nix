{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-03-17";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "bcaa21031d50b90bf873b5e952f30b4721fadfc0";
    hash = "sha256-KqIkenKJwn6QssUOJDwusDU/h9K5DSWPxflbmoWUMEY=";
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
