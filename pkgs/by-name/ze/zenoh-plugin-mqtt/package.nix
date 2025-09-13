{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-mqtt";
  version = "1.4.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = version;
    hash = "sha256-ijoKL8TReNER3a9dwsPeh56l1Ze2rz6jN6L9rYQLYRU=";
  };

  cargoHash = "sha256-ZKpyVVzXC+c7JzktSOMubWl610ujoZ3Vgo4tC0/1JHk=";

  # Some test time out
  doCheck = false;

  meta = {
    description = "Zenoh plug-in that allows to integrate and/or route MQTT pub/sub with Eclipse Zenoh";
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
