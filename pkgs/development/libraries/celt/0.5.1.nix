{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "0.5.1.3";

  src = fetchurl {
    url = "http://downloads.xiph.org/releases/celt/celt-${version}.tar.gz";
    sha256 = "0bkam9z5vnrxpbxkkh9kw6yzjka9di56h11iijikdd1f71l5nbpw";
  };

  # Don't build tests due to badness with ec_ilog
  prePatch = ''
    substituteInPlace Makefile.in \
      --replace 'SUBDIRS = libcelt tests' \
                'SUBDIRS = libcelt'
  '';
})
