{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tailscalesd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cfunkhouser";
    repo = "tailscalesd";
    rev = "v${version}";
    hash = "sha256-FaM2kr3fBC1R2Kgvf5xz4zAw8JQGOmN3fQhHayB/Zs0=";
  };

  vendorHash = "sha256-/nmX0Zqwda5LRC9cmLneU1NJa/VL8vgG284BtjiNTbE=";

  meta = {
    description = "Prometheus Service Discovery for Tailscale";
    changelog = "https://github.com/cfunkhouser/tailscalesd/releases/tag/v${version}";
    homepage = "https://github.com/cfunkhouser/tailscalesd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "tailscalesd";
  };
}
