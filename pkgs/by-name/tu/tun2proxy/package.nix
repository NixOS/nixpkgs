{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.17";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-QcXFDR5JbjGX2KjGBD2Wd5eSFVTxfXUkSCWhV5QO+r4=";
  };

  cargoHash = "sha256-jzUL342AOgaWnS1NBbI/WMXiGHht+eva3yGVlAQeJfo=";

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
