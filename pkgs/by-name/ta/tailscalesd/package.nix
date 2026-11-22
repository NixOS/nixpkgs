{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "tailscalesd";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cfunkhouser";
    repo = "tailscalesd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-FaM2kr3fBC1R2Kgvf5xz4zAw8JQGOmN3fQhHayB/Zs0=";
  };

  patches = [
    # https://github.com/cfunkhouser/tailscalesd/pull/39
    ./go-1.27.patch
  ];

  vendorHash = "sha256-zTuN7CtujEJbDbQJgPJqvRXVDMVw3gp0J3hG4F3CXu8=";

  meta = {
    description = "Prometheus Service Discovery for Tailscale";
    changelog = "https://github.com/cfunkhouser/tailscalesd/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/cfunkhouser/tailscalesd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    mainProgram = "tailscalesd";
  };
})
