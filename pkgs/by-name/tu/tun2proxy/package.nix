{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tun2proxy";
    repo = "tun2proxy";
    rev = "refs/tags/v${version}";
    hash = "sha256-LY7vVD85GVFqARYOBDeb4fS6rL2PwPXYXIAJtwm2goo=";
  };

  cargoHash = "sha256-o/zQjWR9qNs0XVL/dcRiMHgj+8Xvl6vVl/Yw5iLhroI=";

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
