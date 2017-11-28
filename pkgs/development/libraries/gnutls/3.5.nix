{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.5.15";

  src = fetchurl {
    url = "mirror://gnupg/gnutls/v3.5/gnutls-${version}.tar.xz";
    sha256 = "1mgsxkbs44csw07ngwbqns2y2s03m975lk1sl5ay87wbic882q04";
  };

  # Skip two tests introduced in 3.5.11.  Probable reasons of failure:
  #  - pkgconfig: building against the result won't work before installing
  #  - trust-store: default trust store path (/etc/ssl/...) is missing in sandbox
  postPatch = ''
    sed '2iexit 77' -i tests/pkgconfig.sh
    sed '/^void doit(void)/,$s/{/{ exit(77);/; t' -i tests/trust-store.c
  '';
})
