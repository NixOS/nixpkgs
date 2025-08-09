{ callPackage, fetchurl }:

callPackage ./unwrapped.nix (rec {
  version = "0.99";
  src = fetchurl {
    url = "https://downloads.factorcode.org/releases/${version}/factor-src-${version}.zip";
    sha256 = "f5626bb3119bd77de9ac3392fdbe188bffc26557fab3ea34f7ca21e372a8443e";
  };
})
