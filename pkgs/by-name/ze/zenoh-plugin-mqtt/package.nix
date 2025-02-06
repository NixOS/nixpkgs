{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-mqtt";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = version;
    hash = "sha256-ath1RWr+5nU2GJY6rlWPPBKHX9K/92DFUhgQWVXoWb8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Sj50OcIbpP9O+cp5FxmmOg/9iYBFvqh8s2cOOaDwHSA=";

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
