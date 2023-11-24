{ callPackage, fetchurl }:

callPackage ./generic.nix rec {
  version = "3.9.1";

  src = fetchurl {
    url = "mirror://gnu/nettle/nettle-${version}.tar.gz";
    hash = "sha256-zP7/mBsMpxu9b7ywVPQHxg/7ZEOJpb6A1nFtW1UMbOM=";
  };
}
