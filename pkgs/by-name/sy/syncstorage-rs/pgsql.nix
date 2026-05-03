{
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  python3,
  cmake,
  openssl,
  libpq,
  makeBinaryWrapper,
  lib,
  nix-update-script,
  nixosTests,
}@args:

(import ./common.nix args).overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "${prevAttrs.pname}-pgsql";

    cargoHash = "sha256-YgJPDGT0aeCi/x42o6H42ivCiBhP5hhgIEukYfWX1Gg=";

    patches = [
      ./01-syncserver-tokenserver-postgres-db.patch
    ];

    buildFeatures = [
      "postgres"
    ];

    buildInputs = prevAttrs.buildInputs ++ [
      libpq
    ];

    passthru.tests = { inherit (nixosTests) firefox-syncserver-postgresql; };

    meta = prevAttrs.meta // {
      description = "${prevAttrs.meta.description} (PostgreSQL database build)";
    };
  }
)
