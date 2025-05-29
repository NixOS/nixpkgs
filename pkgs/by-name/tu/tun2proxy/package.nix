{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.7.6";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit version;
    hash = "sha256-hAZZ9pSoIgAb4JYhi9mGHMD4CIjnxVJU00PDsQe6OLY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-A/hBV/koIR7gLIZVCoaRk5DI11NZ5HI+xn6qkU+fxaI=";

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
