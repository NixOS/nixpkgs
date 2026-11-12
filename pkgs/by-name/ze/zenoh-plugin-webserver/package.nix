{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-webserver";
  version = "1.10.2"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = finalAttrs.version;
    hash = "sha256-jML032Pxr7B6MPK1+vKT5baBduL8c2SqjgzKaBcEALM=";
  };

  cargoHash = "sha256-qwLiYWDBFm/VYfunOnGJFA1HQy1ZRWf375p8kRkHNzI=";

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
