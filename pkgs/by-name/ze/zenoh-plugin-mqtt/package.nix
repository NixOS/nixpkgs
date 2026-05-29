{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-mqtt";
  version = "1.9.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = finalAttrs.version;
    hash = "sha256-f5y9zCUTvNG/ubw0K+AwqfQlsfeLvoUL8gy3v9T0oQ4=";
  };

  cargoHash = "sha256-vL5lZOH8juX8zaLJZnw1y8aDZsdFC3gELNvp5MPft2o=";

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
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "zenoh-bridge-mqtt";
  };
})
