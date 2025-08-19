{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2025-06-27";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "f293424e46b51a8dc295a0edf0fe7217ebda2660";
    hash = "sha256-0fFQbzj4CZ78P7A3iTwNA6LHUDM0nwYM/mPwDOlV2Zo=";
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
