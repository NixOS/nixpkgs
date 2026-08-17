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
  version = "1.36.0";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    tag = finalAttrs.version;
    hash = "sha256-jc2f7Ia2c+U1cQBXmyzfQAgFMFoAPexLejs6/FKaN9I=";
  };

  cargoHash = "sha256-sjWBM9SsI/7AQ8SuFiTR19l8kqp3rhy64Uh/1TatH6A=";

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
