{ buildEnv
, cairo
, clang
, fetchurl
, gnustep_base, gnustep_make, gnustep_gui
, xlibs
, x11
, freetype
, pkgconfig
, stdenv
}:
let
  version = "0.24.0";
in
stdenv.mkDerivation rec {
  name = "gnustep-back-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-back-0.24.0.tar.gz";
    sha256 = "0qixbilkkrqxrhhj9hnp7ygd5gs23b3qbbgk3gaxj73d0xqfvhjz";
  };
  buildInputs = [ cairo clang freetype gnustep_base gnustep_make gnustep_gui pkgconfig x11 ];
  propagatedBuildInputs = [ ];
  GNUSTEP_env = buildEnv {
    name = "gnustep-back-env";
    paths = [ gnustep_make gnustep_base gnustep_gui ];
    pathsToLink = [ "/bin" "/sbin" "/include" "/lib" "/share" ];
  };
  GNUSTEP_MAKEFILES = "${GNUSTEP_env}/share/GNUstep/Makefiles";
  GNUSTEP_INSTALLATION_DOMAIN = "SYSTEM";
  ADDITIONAL_CPPFLAGS = "-DGNUSTEP";
  patches = [ ./fixup-tools.patch ];
  dontBuild = true;
  installPhase = ''
    export ADDITIONAL_INCLUDE_DIRS=${GNUSTEP_env}/include
    ./configure
    make \
      GNUSTEP_SYSTEM_APPS=$GNUSTEP_env/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_ADMIN_APPS=$GNUSTEP_env/lib/GNUstep/Applications \
      GNUSTEP_SYSTEM_WEB_APPS=$GNUSTEP_env/lib/GNUstep/WebApplications \
      GNUSTEP_SYSTEM_TOOLS=$GNUSTEP_env/bin \
      GNUSTEP_SYSTEM_ADMIN_TOOLS=$GNUSTEP_env/sbin \
      GNUSTEP_SYSTEM_LIBRARY=$GNUSTEP_env/lib/GNUstep \
      GNUSTEP_SYSTEM_HEADERS=$GNUSTEP_env/include \
      GNUSTEP_SYSTEM_LIBRARIES=$GNUSTEP_env/lib \
      GNUSTEP_SYSTEM_DOC=$GNUSTEP_env/share/GNUstep/Documentation \
      GNUSTEP_SYSTEM_DOC_MAN=$GNUSTEP_env/share/man \
      GNUSTEP_SYSTEM_DOC_INFO=$GNUSTEP_env/share/info \
      GNUSTEP_SYSTEM_LIBRARIES=$GNUSTEP_env/lib \
      messages=yes
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
    description = "GNUstep-back is a generic backend for GNUstep.";
    
    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}
