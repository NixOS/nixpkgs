{
  pkgs,
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "terraform-config-inspect";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-config-inspect";
    rev = "f4be3ba97d948a481dfaf17efe961b135d80741b";
    hash = "sha256-KvjlgxcJExMdtWyaM+rMbSrY4X4sjtYEauZA6Tj3pn0=";
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
