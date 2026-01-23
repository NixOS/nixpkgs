{
  fetchFromGitHub,
  lib,
  nixosTests,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "udp-over-tcp";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "mullvad";
    repo = "udp-over-tcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nlLo5/CpieBuRpQyd0eybfkltZyt4qeiupkbtfL/qWE=";
  };

  cargoHash = "sha256-s72C+7q56dSwrmkUBy871rF1MvPkhg8780S+dN/ETh0=";
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
