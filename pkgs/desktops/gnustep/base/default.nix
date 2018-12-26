{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchurl
, gmp, gnutls
, libffi, libbfd
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libobjc, libgcrypt
, icu
, pkgconfig, portaudio
}:
let
  version = "1.25.1";
in
gsmakeDerivation {
  name = "gnustep-base-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${version}.tar.gz";
    sha256 = "17mnilg28by74wc08nkwp6gi06x3j2nrcf05wg64nrw5ljffp2zj";
  };
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi libbfd
    libjpeg libtiff libpng giflib libungif
    libxml2 libxslt libiconv
    libobjc libgcrypt
    icu
    portaudio
  ];
  patches = [ ./fixup-paths.patch ];
  meta = {
    description = "An implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
  };
}
