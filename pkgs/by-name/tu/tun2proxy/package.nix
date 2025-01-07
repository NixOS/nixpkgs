{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "tun2proxy";
    repo = "tun2proxy";
    tag = "v${version}";
    hash = "sha256-zuJFsmoq50fK3W2oL+FmslkIXgCdJvA9ZnXK3sFBbt0=";
  };

  cargoHash = "sha256-+YYzbSCr0NIyqP9HSvt+8x7Aq8IochLBs/PgjvkdriA=";

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
