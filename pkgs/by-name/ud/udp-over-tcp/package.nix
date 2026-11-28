{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "udp-over-tcp";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "udp-over-tcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+1jbBOLQ7uB1QxqiOHRO5vkGChl26z/AZkjxvG07P0c=";
  };

  cargoHash = "sha256-CI+wm574J5qsTaEODlm2UqvD9KN8gZJ8e500aFdx35E=";
  cargoBuildFlags = [
    "--bins"
    "--features"
    "clap"
  ];

  passthru.tests = {
    inherit (nixosTests) udp-over-tcp;
  };

  meta = {
    homepage = "https://github.com/mullvad/udp-over-tcp";
    description = "Proxy UDP traffic over a TCP stream";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ timschumi ];
    # No single mainProgram is listed here because tcp2udp and udp2tcp are equally important.
  };
})
