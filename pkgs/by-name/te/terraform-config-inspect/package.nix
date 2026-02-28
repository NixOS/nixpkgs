{
  pkgs,
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:
buildGoModule {
  pname = "terraform-config-inspect";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "terraform-config-inspect";
    rev = "813a9753022088a8e29290e3ba8806131a3329c2";
    hash = "sha256-kjX7tSU5p5kssqIDnxuLyfmUul8UH83Aeq7ftN0HJCM=";
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
