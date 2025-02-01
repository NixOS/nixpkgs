{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-backend-influxdb";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = version;
    hash = "sha256-npkQEr1tzY+CW9dDRe+JipXnWa5y38wv7J+kUMlcH54=";
  };

  cargoHash = "sha256-AQNbiK7cn0R/DsW1RjKFX3hV3MBX9izPsljJU7yNDV0=";

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
