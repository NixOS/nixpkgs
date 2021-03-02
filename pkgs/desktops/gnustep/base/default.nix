{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchurl, fetchpatch
, gmp, gnutls
, libffi, binutils-unwrapped
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libobjc, libgcrypt
, icu
, pkg-config, portaudio
, libiberty
}:
let
  version = "1.27.0";
in
gsmakeDerivation {
  name = "gnustep-base-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${version}.tar.gz";
    sha256 = "10xjrv5d443wzll6lf9y65p6v9kvx7xxklhsm1j05y93vwgzl0w8";
  };
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi binutils-unwrapped
    libjpeg libtiff libpng giflib libungif
    libxml2 libxslt libiconv
    libobjc libgcrypt
    icu
    portaudio
    libiberty
  ];
  patches = [
    ./fixup-paths.patch
    (fetchpatch {  # for icu68 compatibility, remove with next update(?)
      url = "https://github.com/gnustep/libs-base/commit/06fa7792a51cb970e5d010a393cb88eb127830d7.patch";
      sha256 = "150n1sa34av9ywc04j36jvj7ic9x6pgr123rbn2mx5fj76q23852";
    })
  ];

  meta = {
    description = "An implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
  };
}
