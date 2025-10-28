{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.10.2";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-/p/1HLHyq7XmWmuMEKktoKtaturybn/CtnXEXx+1GbU=";
  };
}
