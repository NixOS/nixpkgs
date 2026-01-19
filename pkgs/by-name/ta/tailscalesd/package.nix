{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tailscalesd";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cfunkhouser";
    repo = "tailscalesd";
    rev = "v${version}";
    hash = "sha256-avGgkGgzeupZwqRPT1juRyTs6udpefTI0W0rqmvhwk0=";
  };

  vendorHash = "sha256-DowF+3eTe+bC3wqfIznCaLwcl42vRyEzFCbMRZffZS8=";

  meta = {
    description = "Prometheus Service Discovery for Tailscale";
    changelog = "https://github.com/cfunkhouser/tailscalesd/releases/tag/v${version}";
    homepage = "https://github.com/cfunkhouser/tailscalesd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "tailscalesd";
  };
}
