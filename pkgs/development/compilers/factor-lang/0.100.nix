{ callPackage, fetchurl, ... }@args:

(callPackage ./unwrapped.nix (
  rec {
    version = "0.100";
    src = fetchurl {
      url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
      hash = "sha256-ei1x6mgEoDVe1mKfoWSGC9RgZCONovAPYfIdAlOGi+0=";
    };
  }
  // (builtins.removeAttrs args [
    "callPackage"
    "fetchurl"
  ])
)).overrideAttrs
  (oA: {
    meta = (oA.meta or { }) // {
      problems.removal.message = "Package to be removed in release following 26.11";
    };
  })
