{
  pkgs,
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "terraform-config-inspect";
  version = "0-unstable-2026-07-09";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-config-inspect";
    rev = "2fb54c236733ee65ee877105d595c124c993c64d";
    hash = "sha256-f8DyPP0XhOlgVdp0yjjFVyjaO2+ypfMfEEv6lwA8u3M=";
  };

  vendorHash = "sha256-iYrSk9JqxvhYSJuSv/nhZep41gRr644ZzGFWXMGQgyc=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    mainProgram = "terraform-config-inspect";
    description = "CLI for shallow inspection of Terraform configurations";
    homepage = "https://github.com/hashicorp/terraform-config-inspect";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ drakon64 ];
  };
}
