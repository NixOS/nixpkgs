{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "tun2proxy";
    repo = "tun2proxy";
    rev = "v${version}";
    hash = "sha256-EeSXEPg4TxbjQXoM2jx8T9+VOT7VndBnxhy7pwwQ8Kk=";
  };

  cargoHash = "sha256-WwCUSnXSlSrO+YfqpZlC9WWsX/pM6ixYlqU1pZY4e5o=";

  cargoPatches = [
    ./Cargo.lock.patch
  ];

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
