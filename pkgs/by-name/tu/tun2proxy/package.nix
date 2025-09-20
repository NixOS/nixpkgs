{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.15";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-Yyct1yGSXbZf49t4+8hP+V4ydyIi7zyff5IIqrTfJS0=";
  };

  cargoHash = "sha256-DhfUhjA8/+gmIe+91vVnK7Zca0x0r6lisTxPmg5yM8k=";

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
