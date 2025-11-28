{
  pkgs,
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "terraform-config-inspect";
  version = "0-unstable-2025-08-28";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-config-inspect";
    rev = "225c06ed5fd99341e37f199aed9c91e829c14be1";
    hash = "sha256-3zl2rGij/DBwFOKCLQIkadgKhHYOA+e7v5qrU2qbd+g=";
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
