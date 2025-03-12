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
    tag = "v${version}";
    hash = "sha256-LY7vVD85GVFqARYOBDeb4fS6rL2PwPXYXIAJtwm2goo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-jlU6zR1W4rRNiU2mMEUzlqK3WqwRd0YncpN01EnzStw=";

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
