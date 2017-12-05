{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.14";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "1nhv0mf3apz65ljh335l8xds7wpn08ywljkrvws08apljbn2v8aa";
  };

  # Skip two tests introduced in 3.5.11.  Probable reasons of failure:
  #  - pkgconfig: building against the result won't work before installing
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox
  postPatch = ''
    sed '2iexit 77' -i tests/pkgconfig.sh
    sed '/^void doit(void)/,$s/{/{ exit(77);/; t' -i tests/trust-store.c
  '';
})
