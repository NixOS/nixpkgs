{ aspell, audiofile
, buildEnv
, clang, cups
, fetchurl
, gmp, gnustep_make, gnutls
, libffi
, libjpeg, libtiff, libpng, giflib, libungif
, libxml2, libxslt, libiconv
, libobjc2, libgcrypt
, icu
, pkgconfig, portaudio
, stdenv
, which
}:
let
  version = "1.24.7";
in
stdenv.mkDerivation rec {
  name = "gnustep-base-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-base-1.24.7.tar.gz";
    sha256 = "0qhphw61ksyzf04a4apmvx8000alws6d92x8ila1mi5bapcpv41s";
  };
  buildInputs = [
    aspell audiofile
    clang cups
    gmp gnustep_make gnutls
    libffi
    libjpeg libtiff libpng giflib libungif
    libxml2 libxslt libiconv
    libobjc2 libgcrypt
    icu
    pkgconfig portaudio
    which
  ];
  propagatedBuildInputs = [
    aspell audiofile
    cups
    gmp gnutls
    libffi
    libjpeg libtiff libpng giflib libungif
    libxml2 libxslt libiconv
    libobjc2 libgcrypt
    icu
    portaudio
  ];
  GNUSTEP_env = buildEnv {
    name = "gnustep-make-env";
    paths = [ gnustep_make ];
  };
  GNUSTEP_MAKEFILES = "${GNUSTEP_env}/share/GNUstep/Makefiles";
  GNUSTEP_INSTALLATION_DOMAIN = "SYSTEM";
  patches = [ ./fixup-base-makefile-installdir.patch ];
  dontBuild = true;
  installPhase = ''
    ./configure --disable-importing-config-file
    make
    make install \
      GNUSTEP_INSTALLATION_DOMAIN=SYSTEM \
      GNUSTEP_SYSTEM_APPS=$out/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_ADMIN_APPS=$out/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_WEB_APPS=$out/lib/GNUstep/WebApplications \
      GNUSTEP_SYSTEM_TOOLS=$out/bin \
      GNUSTEP_SYSTEM_ADMIN_TOOLS=$out/sbin \
      GNUSTEP_SYSTEM_LIBRARY=$out/lib/GNUstep \
      GNUSTEP_SYSTEM_HEADERS=$out/include \
      GNUSTEP_SYSTEM_LIBRARIES=$out/lib \
      GNUSTEP_SYSTEM_DOC=$out/share/GNUstep/Documentation \
      GNUSTEP_SYSTEM_DOC_MAN=$out/share/man \
      GNUSTEP_SYSTEM_DOC_INFO=$out/share/info \
      GNUSTEP_SYSTEM_LIBRARIES=$out/lib \
      GNUSTEP_HEADERS=$out/include \
      DESTDIR_GNUSTEP_MAKEFILES=$out/share/GNUstep/Makefiles
  '';
  meta = {
    description = "GNUstep-base is an implementation of AppKit and Foundation libraries of OPENSTEP and Cocoa.";

    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}
