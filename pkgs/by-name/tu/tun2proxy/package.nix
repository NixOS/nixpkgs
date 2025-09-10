{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tun2proxy";
  version = "0.7.14";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit (finalAttrs) version;
    hash = "sha256-rrBlCtimcQJ8487X5wxsWVk20v9UK0+0B6HRdzV5Sj0=";
  };

  cargoHash = "sha256-73SHsJUvPTvI3kxkpNI2Go11TWyQ8/SckuQBCkWjixA=";

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
