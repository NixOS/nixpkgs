{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.5";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "1bks1zpmhmnkz2v32dd9b44pz6x0a5w4yi9zzwsd0a078vhbi25g";
  };

  # This fixes some broken parallel dependencies
  postPatch = ''
    sed -i 's,^BUILT_SOURCES =,\0 systemkey-args.h,g' src/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook ];
})
