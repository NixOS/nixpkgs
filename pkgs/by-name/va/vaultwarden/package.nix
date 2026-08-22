{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  pkg-config,
  openssl,
  libiconv,
  dbBackend ? "sqlite_system",
  libmysqlclient,
  libpq,
  sqlite,
}:

let
  webvault = callPackage ./webvault.nix { };
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vaultwarden";
  version = "1.37.2";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = finalAttrs.version;
    hash = "sha256-ugCkpeDVK3qPYSvL78N3mzu2bYTFlZP2AQeIgsrIYO8=";
  };

  cargoHash = "sha256-EtdBMCp5aAKsKVM7PwsvJLyW661XdqduhBgk3msYioQ=";

  # used for "Server Installed" version in admin panel
  env.VW_VERSION = finalAttrs.version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optional (dbBackend == "mysql") libmysqlclient
  ++ lib.optional (dbBackend == "postgresql") libpq
  ++ lib.optional (dbBackend == "sqlite_system") sqlite;

  buildFeatures = dbBackend;

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix { };
  };

  meta = {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    changelog = "https://github.com/dani-garcia/vaultwarden/releases/tag/${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      SuperSandro2000
    ];
    mainProgram = "vaultwarden";
  };
})
