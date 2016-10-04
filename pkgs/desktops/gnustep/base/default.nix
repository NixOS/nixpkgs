{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchurl
, gmp, gnutls
, libffi
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libobjc, libgcrypt
, icu
, pkgconfig, portaudio
}:
let
  version = "1.24.9";
in
gsmakeDerivation {
  name = "gnustep-base-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${version}.tar.gz";
    sha256 = "1vvjlbqmlwr82b4pf8c62rxjgz475bmg0x2yd0bbkia6yvwhk585";
  };
  nativeBuildInputs = [ pkgconfig ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi
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
