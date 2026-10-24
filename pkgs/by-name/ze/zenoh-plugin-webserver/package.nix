{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zenoh-plugin-webserver";
  version = "1.10.1"; # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = finalAttrs.version;
    hash = "sha256-1YMLy1kpEgF3zPbyekK12OMXOH/MI51dGNYE2QNK48U=";
  };

  cargoHash = "sha256-LhX9Dpnma67fHNg1dBNhmmUBjftv8vT2kKeFSL6WebU=";

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
