{ callPackage, fetchurl, ... }@args:

callPackage ./generic.nix (
  args
  // rec {
    version = "0.5.1.3";

    src = fetchurl {
      url = "https://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
      hash = "sha256-/C5baDgutDajjDEEaEpsSU35veEzwTn7uj3bXX6qai4=";
    };

    # Don't build tests due to badness with ec_ilog
    prePatch = ''
      substituteInPlace Makefile.in \
        --replace 'SUBDIRS = libcelt tests' \
                  'SUBDIRS = libcelt'
    '';
  }
)
