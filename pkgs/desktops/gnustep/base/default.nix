{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchzip
, gmp, gnutls
, libffi, binutils-unwrapped
, libjpeg, libtiff, libpng, giflib
, libxml2, libxslt, libiconv
, libobjc, libgcrypt
, icu
, pkg-config, portaudio
, libiberty
}:
gsmakeDerivation rec {
  pname = "gnustep-base";
  version = "1.28.0";
  src = fetchzip {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/${pname}-${version}.tar.gz";
    sha256 = "05vjz19v1w7yb7hm8qrc41bqh6xd8in7sgg2p0h1vldyyaa5sh90";
  };
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi binutils-unwrapped
    libjpeg libtiff libpng giflib giflib
    libxml2 libxslt libiconv
    libobjc libgcrypt
    icu
    portaudio
    libiberty
  ];
  patches = [
    ./fixup-paths.patch
  ];

  meta = {
    description = "An implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
    changelog = "https://github.com/gnustep/libs-base/releases/tag/base-${builtins.replaceStrings [ "." ] [ "_" ] version}";
  };
}
