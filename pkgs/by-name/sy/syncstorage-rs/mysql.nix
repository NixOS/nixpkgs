{
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  pkg-config,
  python3,
  cmake,
  openssl,
  libmysqlclient,
  makeBinaryWrapper,
  lib,
  nix-update-script,
  nixosTests,
}@args:

(import ./common.nix args).overrideAttrs (
  finalAttrs: prevAttrs: {
    pname = "${prevAttrs.pname}-mysql";

    cargoHash = "sha256-YgJPDGT0aeCi/x42o6H42ivCiBhP5hhgIEukYfWX1Gg=";

    buildFeatures = [
      "mysql"
    ];

    buildInputs = prevAttrs.buildInputs ++ [
      libmysqlclient
    ];

    passthru.tests = { inherit (nixosTests) firefox-syncserver-mariadb; };

    meta = prevAttrs.meta // {
      description = "${prevAttrs.meta.description} (MySQL database build)";
    };
  }
)
