{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "0.5.1.3";

    src = fetchurl {
      url = "https://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

    # Don't build tests due to badness with ec_ilog
    prePatch = ''
      substituteInPlace Makefile.in \
        --replace 'SUBDIRS = libcelt tests' \
                  'SUBDIRS = libcelt'
    '';
  }
)
