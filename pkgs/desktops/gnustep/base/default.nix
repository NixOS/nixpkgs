{ aspell, audiofile
, gsmakeDerivation
, cups
, fetchzip
, fetchpatch
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
  outputs = [ "out" "dev" "lib" ];
  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi binutils-unwrapped
    libjpeg libtiff libpng giflib
    libxml2 libxslt libiconv
    libobjc libgcrypt
    icu
    portaudio
    libiberty
  ];
  patches = [
    ./fixup-paths.patch
    # https://github.com/gnustep/libs-base/issues/212 / https://www.sogo.nu/bugs/view.php?id=5416#c15585
    (fetchpatch {
      url = "https://github.com/gnustep/libs-base/commit/bd5f2909e6edc8012a0a6e44ea1402dfbe1353a4.patch";
      revert = true;
      sha256 = "02awigkbhqa60hfhqfh2wjsa960y3q6557qck1k2l231piz2xasa";
    })
  ];

  meta = {
    description = "An implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa";
    changelog = "https://github.com/gnustep/libs-base/releases/tag/base-${builtins.replaceStrings [ "." ] [ "_" ] version}";
  };
}
