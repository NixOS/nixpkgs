{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-webserver";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = version;
    hash = "sha256-fdnag/IcGMZUti62y3rLMZ3lt42cd3SSa8kZFXVn6BQ=";
  };

  cargoHash = "sha256-YckyHArQG/mYmDdA2qt4Wmw7Agx/CItjIgajJD0O5WA=";

  meta = {
    description = "Implements an HTTP server mapping URLs to zenoh paths";
    homepage = "https://github.com/eclipse-zenoh/zenoh-plugin-webserver";
    license = with lib.licenses; [
      epl20
      asl20
    ];
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.linux;
  };
}
