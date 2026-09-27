{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-webserver";
  version = "1.10.0"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = finalAttrs.version;
    hash = "sha256-1slOQdefLmR1zMSIzpz8mz9SI3ycn7olPesFcXDogRo=";
  };

  cargoHash = "sha256-lbHXaGQaDY44CN/jEkpb/9Xow1CtB+xC0wNGkp3zjV4=";

  meta = {
    description = "Implements an HTTP server mapping URLs to zenoh paths";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-webserver";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
