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
  dbBackend ? "sqlite",
  libmysqlclient,
  libpq,
}:

let
  webvault = callPackage ./webvault.nix { };
in

rustPlatform.buildRustPackage rec {
  pname = "vaultwarden";
  version = "1.34.1";

  src = fetchFromGitHub {
    owner = "dani-garcia";
    repo = "vaultwarden";
    rev = version;
    hash = "sha256-SVEQX+uAYb4/qFQZRm2khOi8ti76v3F5lRnUgoHk8wA=";
  };

  cargoHash = "sha256-Or259iQP89Ptf/XHpkHD08VDyCk/nQcFlyoKRUUQKt0=";

  # used for "Server Installed" version in admin panel
  env.VW_VERSION = version;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.optional (dbBackend == "mysql") libmysqlclient
  ++ lib.optional (dbBackend == "postgresql") libpq;

  buildFeatures = dbBackend;

  passthru = {
    inherit webvault;
    tests = nixosTests.vaultwarden;
    updateScript = callPackage ./update.nix { };
  };

  meta = {
    description = "Unofficial Bitwarden compatible server written in Rust";
    homepage = "https://github.com/dani-garcia/vaultwarden";
    changelog = "https://github.com/dani-garcia/vaultwarden/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      dotlambda
      SuperSandro2000
    ];
    mainProgram = "vaultwarden";
  };
}
