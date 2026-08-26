{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-mqtt";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-mqtt";
    tag = finalAttrs.version;
    hash = "sha256-GLSRs3qV8AwaSPPqAKt/PchIQnlDr0IeqbJkCqkDBY8=";
  };

  cargoHash = "sha256-XteKnrfKrOGbjCz7njaDlxSPOZ73UWt91dg8R2hB3PM=";

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
