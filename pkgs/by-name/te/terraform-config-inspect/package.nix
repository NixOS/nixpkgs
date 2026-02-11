{
  pkgs,
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "terraform-config-inspect";
  version = "0-unstable-2026-02-04";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-config-inspect";
    rev = "477360eb0c774b44c9769c270aa701536576cbd7";
    hash = "sha256-ingQyP+DhVvvz9rL+Pbec3dAYS5Qo5b5l75J98KWws4=";
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
