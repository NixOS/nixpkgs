{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  libpcap,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zond";
  version = "0-unstable-2026-09-11";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zond-rs";
    repo = "zond";
    # https://github.com/zond-rs/zond/issues/1
    rev = "12bcb6181f10f27ba939aa0ebe39d3f05077758b";
    hash = "sha256-UUby3GNU5ttyJuybw9wVpreQxcfYkOQD22j6kLgJWao=";
  };

  cargoHash = "sha256-MO+bYGHZQi0g4d+Mhz7+tF6ZxYDetL2rTievNeJkvQY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libpcap ];

  checkFlagsArray = [
    # Test requires raw socket/packet capture
    "--skip=the_reason_flag_shows_the_packet_behind_a_verdict"
  ];

  __darwinAllowLocalNetworking = true;

  # Some tests fail in strict sandbox on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for Zond Engine";
    homepage = "https://github.com/zond-rs/zond";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "zond";
  };
})
