{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-influxdb";
  version = "1.2.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = version;
    hash = "sha256-Bdsu/1+lotvGyvKia8ZxRnD0o2Y2yoq5xmok4/hE0mI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YcDTwbaVRpl+xULArqSwjni9pWhgE8XGcY67xiDxFa4=";

  meta = {
    description = "Backend and Storages for zenoh using InfluxDB";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-influxdb";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
