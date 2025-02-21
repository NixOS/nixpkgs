{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "tun2proxy";
  version = "0.7.4";

  src = fetchCrate {
    pname = "tun2proxy";
    inherit version;
    hash = "sha256-ccFaFeTqgkDYuMssxOaWHW2oWgbdacyj6k8qF42OzM8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XqiSVndG6Ep8wifgkAILBbKnljeZNehSL8UTf5I9vEU=";

  meta = {
    homepage = "https://github.com/tun2proxy/tun2proxy";
    description = "Tunnel (TUN) interface for SOCKS and HTTP proxies";
    changelog = "https://github.com/tun2proxy/tun2proxy/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "tun2proxy-bin";
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
