{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.6.6";

  src = fetchFromGitHub {
    owner = "tun2proxy";
    repo = "tun2proxy";
    tag = "v${version}";
    hash = "sha256-ylzzeIpM03uWpfoseo+ELVGwoqgc99+KXPQJQj9TcEo=";
  };

  cargoHash = "sha256-HkjoJltqlxU3R3ANIoFTX8B2gUpa94cMbNnUZoLnXSU=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
