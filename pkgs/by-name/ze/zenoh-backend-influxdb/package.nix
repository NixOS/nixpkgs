{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-influxdb";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = version;
    hash = "sha256-X8COHoAf+VG5RXg6KLozxe39a/4oVuiEJLESnEKaCEE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-orTq5cfkCBedUCu0HeCb7VoMaW6GHCXowSzVxiy5EPA=";

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
