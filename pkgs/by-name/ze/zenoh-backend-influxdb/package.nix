{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-backend-influxdb";
  version = "1.10.2"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-backend-influxdb";
    tag = finalAttrs.version;
    hash = "sha256-wzkFk9wmrOV8oeQ7K9QtS6tSnM2H9Yk68hSXjYHMJGQ=";
  };

  cargoHash = "sha256-bpP7QD54nGaT9sDTvUXX0gDkwJxGA6pW9kO6YhyKGcQ=";

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
