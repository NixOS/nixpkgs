{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-backend-influxdb";
  version = "1.10.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = finalAttrs.version;
    hash = "sha256-HK3qLY/z+IDxuQnGMWauSbQxHYyYlvOlcqFL21igg4Q=";
  };

  cargoHash = "sha256-lelUOxzw2ILIXgFckXEfpQV8+bZmeICadUiIIHe+DHk=";

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
