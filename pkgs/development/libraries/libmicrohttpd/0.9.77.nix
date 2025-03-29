{ callPackage, fetchurl }:

callPackage ./generic.nix (rec {
  version = "0.9.77";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    hash = "sha256-nnAjoVESAGDSgGpupME8qZM+zk6s/FyUZNIO3dt2sKA=";
  };
})
