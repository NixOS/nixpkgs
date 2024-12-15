{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "tailscalesd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "cfunkhouser";
    repo = "tailscalesd";
    rev = "v${version}";
    hash = "sha256-OcvLVsPtAIaGTxk5SKNme0+i0PsDc8uY/sDcM/L5yqU=";
  };

  vendorHash = "sha256-cBHAo2RL7Q6TJbv1QYrescMFwbSUnGlOmTqqt8CZ/qc=";

  meta = {
    description = "Prometheus Service Discovery for Tailscale";
    changelog = "https://github.com/cfunkhouser/tailscalesd/releases/tag/v${version}";
    homepage = "https://github.com/cfunkhouser/tailscalesd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "tailscalesd";
  };
}
