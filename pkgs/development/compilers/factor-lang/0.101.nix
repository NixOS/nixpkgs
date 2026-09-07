{ callPackage, fetchurl, ... }@args:

callPackage ./unwrapped.nix (
  rec {
    version = "0.101";
    src = fetchurl {
      url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
      hash = "sha256-uIuk309xZt+sV7WUza/tpeJRA6CnXAajL15X6S6vtFY=";
    };
  }
  // (builtins.removeAttrs args [
    "callPackage"
    "fetchurl"
  ])
)
