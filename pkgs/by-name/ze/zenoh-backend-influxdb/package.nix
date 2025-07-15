{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-influxdb";
  version = "1.4.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = version;
    hash = "sha256-OwIVaWy3rgnn9Cm7sqBvFua2FOCgMQBoxPh+8HkvpB0=";
  };

  cargoHash = "sha256-yOcbg4+hXdecBN3oeuhs6J1PQ43s8oYOBX/CJ3IyoJ0=";

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
