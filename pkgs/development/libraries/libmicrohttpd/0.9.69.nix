{ callPackage, fetchurl, fetchpatch }:

callPackage ./generic.nix ( rec {
  version = "0.9.69";

  src = fetchurl {
    url = "mirror://gnu/libmicrohttpd/libmicrohttpd-${version}.tar.gz";
    sha256 = "sha256-+5trFIt4dJPmN9MINYhxHmXLy3JvoCzuLNVDxd4n434=";
  };

  patches = [
    ((import ./CVE-2023-27371.nix) fetchpatch)
  ];
})
