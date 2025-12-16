{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.18";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-abgknJuP0p5QS2iTyix0Uq6xiQkeTGK+M/weIHoZNgI=";
  };

  cargoHash = "sha256-8DGlQCXXrq5s0TkqpWhgb2Gw1ve8LCxT0KNzZLvd0zY=";

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
