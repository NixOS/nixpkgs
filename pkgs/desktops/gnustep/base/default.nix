{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchurl
, gmp, gnutls
, libffi, binutils-unwrapped
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libobjc, libgcrypt
, icu
, pkgconfig, portaudio
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
  nativeBuildInputs = [ pkgconfig ];
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
  patches = [ ./fixup-paths.patch ];

  meta = {
    description = "An implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
  };
}
