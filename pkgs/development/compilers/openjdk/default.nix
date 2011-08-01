{ stdenv
, fetchurl
, unzip
, procps
, coreutils
, gnugrep
, gnused
, alsaLib
, ant
}:

stdenv.mkDerivation rec {
  name = "openjdk-7b127";

  src = fetchurl {
    url = http://www.java.net/download/openjdk/jdk7/promoted/b147/openjdk-7-fcs-src-b147-27_jun_2011.zip;
    sha256 = "1qhwlz9y5qmwmja4qnxg6sn3pgsg1i11fb9j41w8l26acyhk34rs";
  };

  buildInputs = [ unzip procps ant ];

  postUnpack = ''
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
      --replace /bin/echo ${coreutils}/bin/echo
    substituteInPlace openjdk/jdk/make/common/shared/Defs-utils.gmk \
      --replace /usr/nix/store /nix/store
  '';

  makeFlags = ''
    MKDIR=${coreutils}/bin/mkdir \
    GREP=${gnugrep}/bin/grep \
    EGREP=${gnugrep}/bin/egrep \
    DATE=${coreutils}/bin/date \
    PWD=${coreutils}/bin/pwd \
    TR=${coreutils}/bin/tr \
    SED=${gnused}/bin/sed \
    ALSA_INCLUDE=${alsaLib}/include \
    HEAD=${coreutils}/bin/head \
    CC=${stdenv.gcc}/bin/gcc
  '';

  configurePhase = ''
    make ${makeFlags} sanity
  '';
}

