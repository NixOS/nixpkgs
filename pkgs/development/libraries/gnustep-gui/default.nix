{ buildEnv
, clang
, fetchurl
, gnustep_base, gnustep_make
#, xlibs, x11, freetype
#, pkgconfig
, stdenv }:
let
  version = "0.24.0";
in
stdenv.mkDerivation rec {
  name = "gnustep-gui-${version}";
  src = fetchurl {
    url = "ftp://ftp.gnustep.org/pub/gnustep/core/gnustep-gui-0.24.0.tar.gz";
    sha256 = "0d6jzfcyacxjzrr2p398ysvs1akv1fcmngfzxxbfxa947miydjxg";
  };
  buildInputs = [ clang gnustep_base gnustep_make ];
  propagatedBuildInputs = [ ];
  GNUSTEP_env = buildEnv {
    name = "gnustep-gui-env";
    paths = [ gnustep_make gnustep_base ];
    pathsToLink = [ "/bin" "/sbin" "/include" "/lib" "/share" ];
  };
  GNUSTEP_MAKEFILES = "${GNUSTEP_env}/share/GNUstep/Makefiles";
  GNUSTEP_INSTALLATION_DOMAIN = "SYSTEM";
  ADDITIONAL_CPPFLAGS = "-DGNUSTEP";
  patches = [ ./fixup-gui-makefile-installdir.patch ./fixup-gui-tools-preamble.patch ./fixup-gui-textconverters-preamble.patch ];
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
    description = "GNUstep-gui is a GUI class library of GNUstep.";
    
    homepage = http://gnustep.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ ashalkhakov ];
    platforms = stdenv.lib.platforms.all;
  };
}
