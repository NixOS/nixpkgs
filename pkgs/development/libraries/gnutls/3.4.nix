{ callPackage, fetchurl, autoreconfHook, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "3.4.6";

  src = fetchurl {
    url = "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-${version}.tar.xz";
    sha256 = "1v109px1sy1s731fnawzdsvggdswmr7ha9q5lid4v8pzgznmkdgy";
  };

  # This fixes some broken parallel dependencies
  postPatch = ''
    sed -i 's,^BUILT_SOURCES =,\0 systemkey-args.h,g' src/Makefile.am
  '';

  nativeBuildInputs = [ autoreconfHook ];
})
