{ stdenv
, fetchurl
, unzip
, zip
, procps
, coreutils
, gnugrep
, gnused
, alsaLib
, ant
, freetype
, cups
, gawk
, which
, jdk
}:

stdenv.mkDerivation rec {
  name = "openjdk-7b127";

  src = fetchurl {
    url = http://www.java.net/download/openjdk/jdk7/promoted/b147/openjdk-7-fcs-src-b147-27_jun_2011.zip;
    sha256 = "1qhwlz9y5qmwmja4qnxg6sn3pgsg1i11fb9j41w8l26acyhk34rs";
  };

  buildInputs = [ unzip procps ant which ];

  postUnpack = ''
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
      --replace /usr/nix/store /nix/store
  '';

  makeFlags = ''
    MKDIR=${coreutils}/bin/mkdir \
    CAT=${coreutils}/bin/cat \
    GREP=${gnugrep}/bin/grep \
    EGREP=${gnugrep}/bin/egrep \
    DATE=${coreutils}/bin/date \
    PWD=${coreutils}/bin/pwd \
    TR=${coreutils}/bin/tr \
    SED=${gnused}/bin/sed \
    ALSA_INCLUDE=${alsaLib}/include/alsa/version.h \
    HEAD=${coreutils}/bin/head \
    ZIPEXE=${zip}/bin/zip \
    FREETYPE_HEADERS_PATH=${freetype}/include \
    FREETYPE_LIB_PATH=${freetype}/lib \
    MILESTONE="release" \
    BUILD_NUMBER="127" \
    CUPS_HEADERS_PATH="${cups}/include" \
    USRBIN_PATH="/" \
    COMPILER_PATH="/" \
    DEVTOOLS_PATH="/" \
    NAWK=${gawk}/bin/gawk \
    PRINTF=${coreutils}/bin/printf \
    BOOTDIR=${jdk} \
    CC=${stdenv.gcc}/bin/gcc
  '';

  configurePhase = ''
    make ${makeFlags} sanity
  '';
}

