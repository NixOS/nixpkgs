{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-mqtt";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = version;
    hash = "sha256-boe4AI0U0JHNuChhHOlfCMlKJ0Zo5yUGG3xubR/Msrc=";
  };

  cargoHash = "sha256-uB/geIBpNStXx82zL2sX6e6sLsoWRkbUsx14xLvDdsw=";

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
