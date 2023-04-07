{ callPackage, fetchurl, fetchpatch }:

callPackage ./generic.nix ( rec {
  version = "0.9.71";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "10mii4mifmfs3v7kgciqml7f0fj7ljp0sngrx64pnwmgbzl4bx78";
  };

  patches = [
    ((import ./CVE-2023-27371.nix) fetchpatch)
  ];
})
