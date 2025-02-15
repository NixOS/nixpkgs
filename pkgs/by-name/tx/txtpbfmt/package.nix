{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-01-29";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "feedd8250727ff9e001e735bc7700800b79e0f29";
    hash = "sha256-ePJOTlRvyPAgqbaLkEhYzblUZzqBIyhpvuECWZu42bs=";
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
