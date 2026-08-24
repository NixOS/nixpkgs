{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-backend-influxdb";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = finalAttrs.version;
    hash = "sha256-t8ob870cLWTfkuHlDXcuReP7K0/FM9d8HV8Sj4xaBOE=";
  };

  cargoHash = "sha256-melqspwAzAqX68pSZ5E/MOFBAO1ObpspFFhflt7Lads=";

  meta = {
    description = "Backend and Storages for zenoh using InfluxDB";
    homepage = "https://github.com/eclipse-zenoh/zenoh-backend-influxdb";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
