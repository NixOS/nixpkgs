{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-mqtt";
  version = "1.2.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = version;
    hash = "sha256-5/obCmi9rbbe9kEkAQTla/4W8ebKj80F4sLKli6oSmw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-tMvBAn2FCpvT9O96Nt646t3LMWqhBHWWzRrMGVP1G1g=";

  # Some test time out
  doCheck = false;

  meta = {
    description = "A Zenoh plug-in that allows to integrate and/or route MQTT pub/sub with Eclipse Zenoh";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-mqtt";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
    mainProgram = "zenoh-bridge-mqtt";
  };
}
