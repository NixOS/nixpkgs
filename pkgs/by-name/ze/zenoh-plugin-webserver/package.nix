{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "zenoh-plugin-webserver";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "eclipse-zenoh";
    repo = "zenoh-plugin-webserver";
    tag = version;
    hash = "sha256-+2ta3LdT1YwRs62dyrbmJDCfKDhpWdig1bX0Qq8EoCY=";
  };

  cargoHash = "sha256-4QFiCtAUABvu1663pKdP7foepy7yLoE8KhApiyuARlk=";

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
