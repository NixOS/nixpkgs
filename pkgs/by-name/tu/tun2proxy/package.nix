{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.16";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-VO0dxX2FVKFSW157HYJxvlc2Xe6W+npw+4ls/1ePu80=";
  };

  cargoHash = "sha256-CWaHHKuDr731cf3tms4Sg9NvCjW0TgmxG3vO37z/UrE=";

  env.GIT_HASH = "000000000000000000000000000000000000000000000000000";

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
})
