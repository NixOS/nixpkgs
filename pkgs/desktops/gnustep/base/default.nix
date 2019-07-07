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
  version = "1.26.0";
in
gsmakeDerivation {
  name = "gnustep-base-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-${version}.tar.gz";
    sha256 = "0ws16rwqx0qvqpyjsxbdylfpkgjr19nqc9i3b30wywqcqrkc12zn";
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
